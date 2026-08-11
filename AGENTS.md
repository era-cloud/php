# 项目 Agent 约束

## Docker 操作边界（硬约束）

- 只允许 `stop` / `rm` / `run` **明确命名的本项目测试容器**（`ws-test` 等 `ws-*` 前缀）
- 禁止 `stop` / `rm` 任何其他容器（mysql-test、ingress、caddy、dufs、pgsql、redis、valkey、page-spy、windows、dockur、backups、webdav 等基础设施/其他项目）
- 禁止全量 docker 操作：`docker rm -f $(docker ps -aq)`、`docker stop $(docker ps -q)`、`docker kill $(docker ps -q)`、`docker system prune -af`
- 禁止 `docker compose down`（depend/ 基础设施——除非用户明确授权）
- 操作前先用 `docker ps` 核对容器名归属；不确定则不操作
