# 项目 Agent 约束

## Docker 操作边界（硬约束）

- 只允许 `stop` / `rm` / `run` **明确命名的本项目测试容器**（`ws-test` 等 `ws-*` 前缀）
- 禁止 `stop` / `rm` 任何其他容器（mysql-test、ingress、caddy、dufs、pgsql、redis、valkey、page-spy、windows、dockur、backups、webdav 等基础设施/其他项目）
- 禁止全量 docker 操作：`docker rm -f $(docker ps -aq)`、`docker stop $(docker ps -q)`、`docker kill $(docker ps -q)`、`docker system prune -af`
- 禁止 `docker compose down`（depend/ 基础设施——除非用户明确授权）
- 操作前先用 `docker ps` 核对容器名归属；不确定则不操作

## 分层构建（2026-11-21 起）

- `cli` / `zts` 是 **base**：编译 PHP + 全部 `EXTRA_EXT`（bcmath/bz2/calendar/exif/ffi/gd/gettext/
  intl/mysqli/pcntl/pdo_mysql/pdo_pgsql/shmop/soap/sockets/sysv*/tidy/zip），8.6 同样安装。
- `swoole` / `swow` / `thread` 及 rc 轨是 **扩展层**：`Dockerfile-ext.template`，
  `FROM ghcr.io/era-cloud/php:<ver>-<cli|zts>-<suite>`，只装扩展本体。
  → 扩展版本升级不再重编 PHP（~10 分钟 → ~1 分钟）。
- 扩展变体目录**只保留 Dockerfile**（`docker-php-*` 全部继承自 base）。
- CI 分两阶段：`build-base` → `build-ext`（`needs`），base 构建后**立即同步 ghcr 别名**
  （扩展层的 FROM 是短别名，mirror job 太晚）。
- 扩展层的 `changed` 判断必须连带其 base 变体目录（见 `.github/scripts/variant-changed.sh`），
  否则 PHP 小版本升级（短别名不变）时扩展镜像不会重建。
- 扩展层编译依赖要自带：base 清理阶段会清掉 `-dev` 包（如 `--enable-swoole-pgsql` 需要 `libpq-dev`）。

## tag 规范（2026-11-21 起）

- base（`cli` / `zts`）：`<phpFull>-<variant>-<suite>`、`<phpMinor>-<variant>-<suite>`、
  `<phpMinor>-<variant>`、`<phpMinor>-<suite>`、`<phpMinor>`，`8` / `latest` 指向最新稳定版。
- 扩展层额外带**扩展版本维度**（`swoole` / `swoole-6` / `swoole-6.2` / `swoole-6.2.6`）：
  - 组合：`8.5-swoole-6.2`、`8.5-swoole-6.2.6-alpine3.24`、`8.5.13-swoole-6.2.6(-suite)`
  - **不绑 PHP 版本的短 tag**（`swoole`、`swoole-6.2`）只指向「该变体最新可用 PHP 版本 +
    最新 alpine suite」，且在生成时只会由一个变体目录产出（否则 tag 冲突）。
  - rc 轨只到 `major.minor`：`swoole-rc` / `swoole-6-rc` / `swoole-6.3-rc`；
    完整 rc 号（`6.3.0-rc2`）只写进 `cn.era-cloud.ext.*` label。
  - `thread` 复用 swoole 的版本号（`thread` / `thread-6.2.6`）。
- 一个变体的**第一个 tag** 必须保持 `<phpFull>-<variant>-<suite>`：它是 `matrix.name`，
  也是 `.build-state.json` / `.image-metrics.json` 的键，改动会打乱增量构建。
- tag 数与 registry 规模：当前规则 **846** 个（原 448）；registry 总量见文档站。

## 文档站（docs/，GitHub Pages）

- VitePress（中文、pnpm），站点根目录 `docs/`，线上 <https://era-cloud.github.io/php/>。
- `docs/scripts/collect.mjs`：拉 ghcr 包版本全量 tag + 合并 `versions.json` / `extensions.json` /
  `.image-metrics.json` / `.build-state.json`，输出 `docs/public/data/*.json`（已 gitignore）；
  **无 token / API 失败时自动降级**为仓库内数据。
- **每个 tag 必须解析成具体镜像**：表格里不能出现 `PHP=8 / 变体=—`（用户没法判断
  `docker pull era-cloud/php:8` 到底拉到什么）。`collect.mjs` 的 `resolveTag` 负责把
  `8` / `latest` / `cli` / `trixie` / `8.5-swoole` / `swoole-6.2` 解析成
  `php 完整版本 + 变体 + suite`，缺字段的 tag 额外显示一行 `→ 8.6.0-cli-trixie`。
  规则：不带 PHP 版本的纯轨道 tag（`swoole`、`swoole-6.2`）落在**最新 alpine**；
  带 PHP 版本但没写 suite 的（`8.5-swoole`）落在**默认 debian**（trixie）。
- 数据拆分：`current.json`（约 350KB）默认加载，`archived.json`（约 1.5MB）勾选「含历史」时才拉。
- 体积口径：**解压后 = `docker export` 展开后的字节数**，下载 = registry 清单压缩层总量。
  ⚠️ 不要用 `docker save`：containerd 镜像存储下它导出的是压缩块（实测 192MB vs export 547MB），
  `docker image inspect .Size` 在 CI 上同样是压缩值。回填用 `measure-size.yml`（手动 dispatch）。
- `docs/.vitepress/config.ts` 的 `srcExclude` 排除了 `design-layering.md`（内部设计文档）。
- `.github/workflows/docs.yml`：`ci.yml` 成功后自动构建部署，也可 `workflow_dispatch`。
- `docs/design-layering.md` 只放**内部设计**，不要往站点页面里引。
- 改 `docs/` 只触发 Release→ci（变体全部 skipped）→docs，不会重建镜像。

## 构建与变体约束（踩过坑，勿回退）

### 变体矩阵

| PHP | 变体 |
|---|---|
| 8.2 / 8.3 / 8.4 / 8.5 | `cli` `swoole` `zts` `swow` `thread` |
| 8.6+（当前 8.6-rc） | 仅 `cli` `zts` |

- 8.6 没有 `swoole` / `swow` / `thread`：**不存在任何可编译于 PHP 8.6 的版本**。swoole master 的 `composer.json` 明写 `php >=8.2 <8.6`；swow 的 develop 也挂在 `zend_parse_arg_str_weak` / `XtOffsetOf` 上。不是版本选择问题，等上游适配后再加。
- 变体列表在 `versions.sh` 的 jq 里控制（`IN("8.2", "8.3", "8.4", "8.5")` 条件）。`.github/workflows/check-86-extensions.yml` 每周会用已发布的 8.6 镜像实编译 swoole / swow，能编过就自动开 issue 提醒恢复。

### 扩展安装（PIE）

- 本 fork 所有版本都走 PIE（`def install_pie: true`），不再按版本判断。
- PHP 8.6 的四个核心扩展必须 pin 到具体开发提交（正式版都没适配 8.6），定义在 `Dockerfile-linux.template` 的 `php86plus` / `pie_msgpack` / `pie_igbinary` / `pie_ds` / `pie_redis`：
  - `msgpack/msgpack-php:dev-master#4a68908…`
  - `igbinary/igbinary:dev-master#2b1f5d6…`
  - `php-ds/ext-ds:dev-master#6e9d668…`
  - `phpredis/phpredis:dev-develop#10ae008…`（默认分支是 **develop**，不是 master）
- 从 VCS 装 dev 版本需要 `git`，因此 8.6+ 构建期会临时装 `git`（alpine 用 `.pie-vcs` 虚拟包），pie 步骤结束后立即清理。

### CI 重建判断

- `ci.yml` 的 “Check variant changed” 只 diff **变体目录本身**（`paths="$variant_dir"`），因为目录里已包含渲染后的 Dockerfile 和被 `apply-templates.sh` 复制进来的 `docker-php-*`。改模板但渲染结果不变时不会触发全量重建。
- 需要强制重建某个变体时，删掉 `.build-state.json` 里对应的 `<完整版本>-<variant>-<suite>` 键即可（`last` 为空 → `changed=true`）。

### 指标与 README

- `.image-metrics.json` 的 tag 用短名（`8.5-cli-trixie`、`8.6-rc-cli-trixie`），`merge-metrics.sh` 的 `norm_tag()` 负责把 artifact 的完整版本标签归一化（`8.6.0RC4-cli-trixie` → `8.6-rc-cli-trixie`）。新增预发布形式时要同步这个正则。
- README 的 PHP 徽章、版本矩阵、镜像矩阵全部由 `update-readme.sh` 生成（对应 `<!-- PHP-BADGE-* -->`、`<!-- VERSION-MATRIX-* -->`、`<!-- TAG-MATRIX-* -->` 三组标记），**不要手改这些区块内部**。

### 上游同步

- 上次同步的上游提交记录在仓库根目录的 `.upstream-sync`；**每次同步完成后必须更新这个文件**（写入 `git -C . rev-parse upstream/master`）。
- `.github/workflows/check-upstream.yml` 每周一 04:00 UTC 比对，发现新提交会自动开/更新提醒 issue。
- 同步流程：`git fetch upstream` → `git merge --no-ff upstream/master` → 解冲突（保持 fork 变体语义、8.6 限制、PIE pin）→ `./apply-templates.sh` → 校验 `8.2-8.5` 渲染结果未变 → 推送。

### 告警

- `.github/workflows/notify-failure.yml`：Release / 构建 / 安全扫描 / 各周检 workflow 失败时推飞书。
- 需要仓库 secret `FEISHU_WEBHOOK`（未配置时只打 warning）。消息内容含失败 workflow、分支、提交、失败 job 列表与日志链接。

### 镜像推送（两个 registry 的压缩方式不同）

- `generate.sh` 的 build 步骤有 **三个输出**：
  1. ghcr：`compression=zstd` + OCI 媒体类型（拉取体积最小）
  2. Aliyun ACR：`compression=gzip` + Docker schema2（ACR 个人版不认 zstd）
  3. `type=docker,name=ghcr.io/era-cloud/<tag>`：本地副本，供 Test / History / 指标步骤使用
- **不要**用 `--tag` + `--load` + `docker push` 推 ACR：新 runner 的 containerd 镜像存储会保留 zstd 层，`docker push` 不再转 gzip，ACR 报 `blob type invalid`。
- 后续步骤里的 `Push images` 只做 `docker manifest inspect` 校验，不再真正上传。

### 陈旧 tag 清理

- `.github/workflows/cleanup-old-tags.yml`：每月 1 日 06:00 UTC 跑一次（dry-run），手动 dispatch 时把 `dry_run` 设为 `false` 才真正删除。
- 只清「完整版本 tag」（`8.5.9-*`、`8.6.0RC5-*` 等）；只要该 package version 上还挂着任何当前版本或别名 tag 就跳过；别名（`8`/`latest`/`8.5-cli`…）永不删除。
- 仅覆盖 GHCR；ACR 需要控制台或 aliyun CLI 清理。

### 全量重建是高成本操作

- 触发一次全量重建 = 88 个变体 × 两份镜像（ghcr zstd + ACR gzip）上传，很容易撞上 ACR 个人版的带宽/配额限制。
- 只在确有必要时触发（新 PHP 版本、模板变更导致渲染差异）；验证脚本/README/CI 逻辑改动**不需要**重建。
- 强制重建单变体的正确姿势：删掉 `.build-state.json` 里对应键；**不要**清空整个文件。

### ACR 同步是独立 job

- `build` job 只负责构建并推 ghcr（+ 本地副本），**不再推 ACR**。
- `mirror` job（同一个 matrix）负责 skopeo 转推到 ACR，`continue-on-error: true`：
  ACR 失败不会让构建失败，失败时会推飞书并留待下一轮重试。
- 只有 `changed=true` 的变体才会真正 mirror（其余变体只跑一次快速 check）。
- **只同步扩展变体**（swoole / swow / thread 及其 rc 轨）：base（cli/zts）体积大（~800MB）、
  用量少，只在 ghcr 提供，不进 ACR。
- 因此 ACR 上的 cli/zts tag 会**停留在停止同步那一刻**；README / 文档站必须标注这一点，
  不要再往 ACR 推 base（否则又变成"部分更新"的假象）。

### 扩展版本跟踪（extensions.json）

- `extensions.json` 记录 6 个扩展的 `stable` / `rc`（各含 `version` 与 `ref`）。
- `extensions.sh` 每天从 Packagist + GitHub API 更新：取最新版本 → 解析成 `dev-<branch>#<sha>` → 写回。
  - 跨大版本（6.x→7.x）不自动升，只打 warning
  - 无纯正式版的包（如 igbinary）回退到最新版本
  - 连续失败（限流/网络）时保留原值，不会把 pin 清空
- 模板用 `env.ext_*` 渲染 `pie install 'pkg:dev-branch#sha'`；`update.sh` 已把 `./extensions.sh` 加在 `versions.sh` 之后。
- **PIE 不能按 tag 安装**（`pkg:6.2.6` / `pkg:v6.2.6` 都会报找不到），所以统一用 commit-sha pin。
- 每个镜像写入 `cn.era-cloud.ext.<name>` label（可读版本号），`docker inspect` 可追溯。
- README 的「扩展版本」区块由 `update-readme.sh` 从 extensions.json 生成（`<!-- EXT-VERSIONS-START/END -->`）。

### 扩展 RC 轨

- 变体名：`swoole-rc` / `thread-rc` / `swow-rc`，只在 `extensions.json` 里对应包存在 `rc` 且该 PHP 版本可用时生成（8.2–8.5；8.6 无 swoole）。
- `swow` 的 pre-release 发布在核心仓库 `swow/swow`（v2.0.0-alpha.3），`swow-extension` 只有 v0.2.0-alpha.1：
  `extensions.sh` 对 swow 特殊处理 —— 版本号取核心仓 tag，ref 指 `swow-extension` 的 develop HEAD。
- 变体矩阵：8.2–8.5 各 32 个（cli/zts + swoole/swow/thread + 三条 rc 轨 × 4 suite），8.6 为 8 个，合计 136。
- README 版本矩阵的列顺序：cli / zts / swoole / swoole-rc / swow / swow-rc / thread / thread-rc。
