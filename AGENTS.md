# 项目 Agent 约束

## Docker 操作边界（硬约束）

- 只允许 `stop` / `rm` / `run` **明确命名的本项目测试容器**（`ws-test` 等 `ws-*` 前缀）
- 禁止 `stop` / `rm` 任何其他容器（mysql-test、ingress、caddy、dufs、pgsql、redis、valkey、page-spy、windows、dockur、backups、webdav 等基础设施/其他项目）
- 禁止全量 docker 操作：`docker rm -f $(docker ps -aq)`、`docker stop $(docker ps -q)`、`docker kill $(docker ps -q)`、`docker system prune -af`
- 禁止 `docker compose down`（depend/ 基础设施——除非用户明确授权）
- 操作前先用 `docker ps` 核对容器名归属；不确定则不操作

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
