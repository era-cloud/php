# 基础镜像（cli / zts）

基础镜像负责编译 PHP 并装好常用扩展。`swoole` / `swow` / `thread` 等扩展镜像都 `FROM` 这里面
对应的 tag，因此**先有 base 才有扩展层**。

## tag 形式

| 形式 | 例子 | 指向 |
| --- | --- | --- |
| PHP 完整版本 + 变体 + suite | `8.5.13-cli-trixie` | 精确版本 |
| PHP 短版本 + 变体 + suite | `8.5-cli-trixie` | 跟随 8.5 的最新补丁 |
| PHP 短版本 + 变体 | `8.5-cli` | 默认 suite（trixie） |
| 只带 suite | `8.5-trixie`、`8.5` | 默认变体（cli） |
| 全局别名 | `8`、`latest` | 当前最新的稳定 PHP（8.6） |
| alpine 简写 | `8.5-cli-alpine` | 最新 alpine suite（当前 alpine3.24） |

## 包含什么

- PHP 本体（CLI / ZTS），`opcache` 默认开启（8.5+ 为内置）
- 通用扩展：`bcmath bz2 calendar exif ffi gd gettext intl mysqli pcntl pdo_mysql pdo_pgsql
  shmop soap sockets sysvmsg sysvsem sysvshm tidy zip`
- 常用第三方扩展：`ds`、`igbinary`、`msgpack`、`redis`（版本由仓库 `extensions.json` 固定）
- composer（阿里云镜像源）
- 默认 ini 调整：`Asia/Shanghai`、上传/内存上限放宽

::: tip 版本追溯
每个镜像都带 OCI label，可直接查扩展版本：

```bash
docker inspect --format '{{json .Config.Labels}}' ghcr.io/era-cloud/php:8.5-cli-trixie | jq .
```

可用字段：`cn.era-cloud.layer`、`cn.era-cloud.ext.<扩展名>`（`msgpack` / `igbinary` / `ext-ds` / `phpredis`）。
:::

## 支持矩阵

| PHP | cli | zts | 发行版 |
| --- | --- | --- | --- |
| 8.6 | ✅ | ✅ | trixie / bookworm / alpine3.24 / alpine3.23 |
| 8.5 | ✅ | ✅ | 同上 |
| 8.4 | ✅ | ✅ | 同上 |
| 8.3 | ✅ | ✅ | 同上 |
| 8.2 | ✅ | ✅ | 同上 |

8.6 目前只有 `cli` / `zts`：swoole 还没有支持 PHP 8.6 的版本。

## tag 列表

<TagTable layer="base" />
