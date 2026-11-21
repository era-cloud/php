# 分层构建 + 全矩阵 tag + 文档站：设计与执行计划

> 状态：设计定稿，尚未实施。
> 决策记录见文末「决策」小节（全部已确认）。

## 1. 目标

1. **分层**：`cli` / `zts` 作为 base（编译 PHP + 全部 EXTRA_EXT + redis 增强）；`swoole` / `swow` / `thread` 及其 RC 轨改为 `FROM` 自家 base 镜像，只编译扩展。扩展升级时不再重编 PHP。
2. **全矩阵 tag**：给扩展镜像加上「扩展版本维度」的标签（`swoole-6.2`、`8.5-swoole-6.2.6-alpine3.24` 等）。
3. **文档站**：VitePress（中文）放 `docs/`，独立 CI，展示 base / extensions / 全量 tag（含历史），公开访问。

## 2. 当前状态（2026-11-21）

| 项 | 值 |
|---|---|
| 变体 | 120（8.2–8.5 各 28：cli/zts/swoole/swoole-rc/swow/swow-rc/thread × 4 suite；8.6 的 8：cli/zts） |
| 结构 | 单层：每个变体各自编译 PHP |
| registry tag | 4279（含历史） |
| 扩展版本 | `extensions.json`（commit-sha pin）+ `cn.era-cloud.ext.*` label |
| 扩展 RC 轨 | `swoole-rc` / `swow-rc`（`thread-rc` 已移除：swoole RC 不支持线程模式） |

## 3. 分层设计

### 3.1 层级

```
第一层（base）  cli / zts         FROM debian:<suite>-slim | alpine:<ver>
                                  → 编译 PHP、EXTRA_EXT（bcmath/gd/intl/zip…）、redis 增强
第二层（ext）   swoole / swow     FROM ghcr.io/era-cloud/php:<ver>-cli-<suite>
                thread            FROM ghcr.io/era-cloud/php:<ver>-zts-<suite>
                swoole-rc / swow-rc  同上，装 pre-release
```

- `EXTRA_EXT` 全部进 base（含 8.6）——扩展变体重建时只编 swoole/swow。
- 扩展变体的 `FROM` 使用**短别名**：`ghcr.io/era-cloud/php:8.5-cli-trixie`。
- base 不新增 tag 语义，`cli` / `zts` 即 base。

### 3.2 改动清单

| 文件 | 改动 |
|---|---|
| `Dockerfile-linux.template` | EXTRA_EXT 依赖与 `docker-php-ext-install` 从 swoole/swow 段移到 base 段 |
| `Dockerfile-ext.template`（新建） | 只含扩展段：`FROM <base>` + swoole/swow 安装 + label + 清理 |
| `apply-templates.sh` | 扩展变体走新模板；计算 `from`（短别名）；扩展目录只留 Dockerfile |
| `generate-stackbrew-library.sh` | `getArches` 让自引用父镜像继承 base 的架构列表（否则 `Architectures:` 为空） |
| `.github/scripts/generate.sh` | 矩阵节点增加 `phase`（base / ext） |
| `.github/scripts/variant-changed.sh`（新建） | 统一「变体是否需要重建」判断；扩展层连带其 base 目录 |
| `ci.yml` | 拆成 `build-base` → `build-ext` 两阶段；base job 内立即同步 ghcr 别名 |

### 3.3 实际实现（2026-11-21）

- **两阶段构建**：`build-base`（40 个：cli/zts × 5 版本 × 4 suite）先跑完并同步别名，
  `build-ext`（80 个）由 `needs: build-base` 串起来。没有用 bashbrew 的「同仓父镜像合并」，
  因为那会把 base + 扩展并进同一个 job，导致改扩展版本时连 base 一起重编，失去分层收益。
- **别名同步前置**：`runs.syncAliases` 在 `build` job 内、Build 之后立即执行；
  `mirror` job 里的同名步骤保留（幂等），仅兜底。
- **changed 判断**：扩展层 Dockerfile 只有 `FROM 自家 base 短别名`，所以把 base 变体目录
  一并纳入 `git diff` 范围 —— 否则 PHP 小版本升级（短别名不变）时扩展镜像不会被重建。
- **架构继承**：`generate-stackbrew-library.sh` 预扫描所有 base 变体的 FROM，
  建立 `<ver>-<cli|zts>-<suite>` → 上游父镜像的映射，扩展变体据此取 `Architectures:`。
  本地验证渲染结果为 `amd64, arm32v5, arm32v7, arm64v8, i386, ppc64le, riscv64, s390x`。
- **job outputs 上限**：GitHub 对单个 job 的 outputs 有 **1 MB** 上限（超了 job 直接 failure，
  报错 `Job outputs exceed 1,048,576 bytes`）。所以只导出两个子矩阵（不再导出一份全量），
  用 `jq -c` 压缩，并把 base 的 `runs.push`（ACR 命令）留空 —— 现在 base 82.6 KB + ext 220.7 KB。
  `mirror` job 因此直接用 `strategy_ext`（ACR 只同步扩展变体）。
- **空矩阵兜底**：`workflow_dispatch` 用 `variants` 过滤到只剩一类时，
  另一阶段矩阵为空会让 GitHub 报错，因此塞一个占位节点 + job 级 `if: count != 0`。
- **本地验证**（2026-11-21）：`8.5/trixie/cli` 构建通过，`php -m` 含全部 EXTRA_EXT
  （bcmath bz2 calendar exif FFI gd gettext intl mysqli pcntl pdo_mysql pdo_pgsql shmop
  soap sockets sysvmsg sysvsem sysvshm tidy zip）+ ds/igbinary/msgpack/redis，镜像 768MB；
  随后 `8.5/trixie/swoole` 以 `ghcr.io/era-cloud/php:8.5-cli-trixie` 为 base 构建
  （swoole 6.2.6 正常，label 含 base 引用）。alpine 路线同样验证通过：
  `8.5/alpine3.24/cli` 157MB、`8.5/alpine3.24/swoole` 173MB。

### 3.4 风险

- 自引用 `FROM` 的构建顺序：依赖 `bashbrew list --build-order`；需在 push 前确认顺序正确。
- 官方 `oi/test/run.sh` 继续对扩展变体执行；若断言失败，按实际报错调整（不改测试语义）。

## 4. 全矩阵 tag 设计

### 4.1 语法（以 8.5 + swoole 6.2.6 为例）

```
swoole                     轨道 tag（指向最新可用 PHP + 最新 alpine suite）
swoole-6                   扩展 major
swoole-6.2                 扩展 major.minor
swoole-6.2.6               扩展完整版本
swoole-rc / swoole-6.3-rc  RC 轨
8.5-swoole / 8.5-swoole-6.2 / 8.5-swoole-6.2.6
8.5.13-swoole-6.2.6
8.5-swoole-6.2-alpine3.24 / swoole-6.2-alpine3.24
```

- 无 PHP 版本的 tag（`swoole`、`swoole-6.2`）指向「最新实际存在该扩展的 PHP 版本 + 最新 alpine suite」——当前为 php 8.5 + alpine3.24。
- 不在扩展版本 tag 上使用 `latest` / `8` 等全局别名，避免歧义。

### 4.2 规模（实施后实测，按当前 120 变体）

| 规则 | tag 数 |
|---|---|
| 现有规则 | 448 |
| 全矩阵规则 | **846** |
| 与 registry 现有 4279 的交集 | 459 |
| 需要新建 | **387** |

registry 总量因此从 4279 涨到约 4666。

## 5. 文档站（VitePress）

```
docs/
├─ .vitepress/config.ts      中文站点配置
├─ index.md                  概览 + 快速选择（纯 PHP / swoole 稳定 / swoole RC / 钉死扩展版本）
├─ base.md                   cli / zts：tag、体积、扫描、FROM debian|alpine
├─ extensions.md             swoole / swow / thread + rc：扩展版本、对应 base tag
├─ tags.md                   全量 tag 索引（含历史/已归档）
└─ scripts/collect.mjs       拉 ghcr 包 API 全量 tag + 合并 versions.json / extensions.json /
                             .image-metrics.json / .build-state.json → docs/public/data/*.json
```

- 包管理器：pnpm；部署：`actions/deploy-pages`；触发：`ci.yml` 成功后的 `workflow_run` + 手动 dispatch。
- 可见性：公开。
- README 只保留「稳定轨 / 预发布轨」两张精简表 + 扩展版本小节 + 指向 Pages 的链接。

## 6. 执行顺序

0. **预检**：先只改 `generate-stackbrew-library.sh` 让扩展变体 FROM 自家镜像，跑
   `bashbrew list --build-order` 确认 base 排在扩展前；不对先修。
1. **docs 骨架先上线**：VitePress 空站（config + 三页占位 + `docs.yml` + deploy-pages），
   先跑通 Pages 链路，与 tag 改造解耦。
2. 第一轮：分层（第 3 节全部改动）→ 本地验 `8.5/trixie/cli` + `8.5/trixie/swoole` → 推送 → 120 变体重建。
3. 第二轮：全矩阵 tag（第 4 节）→ 填充 docs 数据（第 5 节）→ 推送。

## 7. 决策

| # | 决策 | 结论 |
|---|---|---|
| D1 | EXTRA_EXT 归属 | 全部进 base（含 8.6） |
| D2 | 分层实现 | 新建 `Dockerfile-ext.template` |
| D3 | 扩展变体 FROM | 短别名 `<ver>-<cli\|zts>-<suite>` |
| D4 | 推送节奏 | 分两轮（先分层，后 tag + docs） |
| D5 | 无 PHP 版本 tag 指向 | 最新可用 PHP + 最新 alpine suite |
| D6 | tag 矩阵范围 | 全矩阵（major / major.minor / full / rc × php × suite） |
| D7 | 文档站 | VitePress，中文，pnpm，`actions/deploy-pages`，公开 |
| D8 | 文档页结构 | base / extensions / tags 三页 + index 快速选择 |
| D9 | 刷新时机 | 跟随构建（`workflow_run`） |
| D10 | 历史 tag | 全量展示（ghcr API），标记已归档 |
| D15 | rc 轨 tag | 只到 major.minor（`swoole-6.3-rc`），完整 rc 号只进 label |
| D16 | thread 版本号 | 与 swoole 相同 |
| D17 | 新 tag 落地方式 | 清空 `.build-state.json` 强制全量重建一次 |
| D18 | docs 数据权限 | 内置 GITHUB_TOKEN（packages:read），失败自动降级 |
| D11 | 构建顺序 | 实施分层前先验 `bashbrew list --build-order`（base 必须排在扩展前） |
| D12 | docs 上线时机 | 先上线 VitePress 空站（骨架 + deploy-pages），再填 tag 数据 |
| D13 | base 体积 | 接受 EXTRA_EXT 全进 base（实测 trixie cli 723MB → 806MB，+83MB 未压缩 / +20MB 压缩） |
| D14 | ACR 同步范围 | 只同步扩展变体（swoole/swow/thread），base 只在 ghcr 提供 |
