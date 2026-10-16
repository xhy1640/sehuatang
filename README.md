# 🌺 Sehuatang 数据抓取系统 (v2 纯享版)

基于 Python 3.11、`curl_cffi` 与 FastAPI 的高性能色花堂论坛抓取系统。
支持多架构 Docker 镜像（**ARM64** 与 **AMD64** 原生支持，兼容 Apple Silicon Mac 与 Linux 服务器）。

---

## ⚡ 特性

- 🐬 **轻量极速**：基于 `curl_cffi` 模拟现代浏览器 TLS/JA3 指纹，无需沉重的无头 Chrome，单容器仅需 150MB~250MB 内存。
- 🍎 **全架构原生支持**：GitHub Actions 自动构建 `linux/amd64` 与 `linux/arm64`（M1/M2/M3/M4 Mac 畅跑）。
- 📊 **结构化入库**：完整提取标题、番号、分类、封面图、发帖时间、磁力链接入库 MongoDB。
- 🖥️ **Web 控制台**：内置 Web 管理面板（默认端口 `8181`），支持任务监控、日志查看、在线修改 YAML 配置与失败重试。
- 🛡️ **纯享聚焦**：剔除无关外部来源，专注 sehuatang 论坛抓取。

---

## 🚀 快速启动（Docker Compose）

### 1. 准备目录与配置

```bash
mkdir -p sehuatang/config sehuatang/logs
cd sehuatang

# 下载 docker-compose.yml 与配置文件模板
wget -O docker-compose.yml https://raw.githubusercontent.com/xhy1640/sehuatang/v2/docker-compose.yml
wget -O config/config.yaml https://raw.githubusercontent.com/xhy1640/sehuatang/v2/config/config.example.yaml
```

### 2. 填写核心配置

编辑 `config/config.yaml`，填入以下关键项：

1. **`mongodb.connection_string`**：MongoDB 数据库连接串。
2. **`sehuatang.cookie`**：论坛登录 Cookie（浏览器登录后 F12 抓取整条 Cookie）。
3. **`crawler.sources.sehuatang.http.proxy.url`**：代理地址（macOS Docker Desktop 请使用 `http://host.docker.internal:7890`）。
4. **`web.token`**：Web 仪表盘访问密码（与 `docker-compose.yml` 中的 `SHT_WEB_TOKEN` 保持一致）。

### 3. 一键启动

```bash
docker compose up -d
```

启动后在浏览器打开：`http://127.0.0.1:8181`，点击右上角 **Token** 填入口令即可使用。

---

## 🛠️ 镜像构建与 CI/CD

本项目通过 GitHub Actions 自动化构建多架构镜像并发布至 Docker Hub：
- **Docker 镜像**：`xhy1640/sehuatang-crawler:latest`
- **支持架构**：`linux/amd64`, `linux/arm64`
