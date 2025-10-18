# 多阶段构建，减小镜像体积
FROM python:3.11-slim as builder

# 构建参数
ARG BUILDTIME
ARG VERSION
ARG REVISION

# 设置工作目录
WORKDIR /app

# 安装构建依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 运行阶段
FROM python:3.11-slim

# 创建非root用户
# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 安装运行时依赖和 Chromium 浏览器
# Install runtime dependencies and Chromium browser, suitable for multi-arch build
RUN apt-get update && apt-get install -y \
    gnupg2 curl wget unzip ca-certificates \
    fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 \
    libcups2 libdbus-1-3 libdrm2 libgbm1 libgtk-3-0 libnspr4 libnss3 \
    libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 从构建阶段复制Python包和依赖
# Copy Python packages and dependencies from builder stage
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# 复制应用代码
COPY --chown=appuser:appuser . .

# 创建必要的目录
# Create necessary directories
RUN mkdir -p /app/logs /app/config \
    && chown -R appuser:appuser /app

# 设置环境变量
# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app
ENV DISPLAY=:99

# 构建信息标签
# Build info labels
ARG BUILDTIME
ARG VERSION
ARG REVISION
LABEL org.opencontainers.image.created=${BUILDTIME}
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.revision=${REVISION}
LABEL org.opencontainers.image.licenses="MIT"

# 暴露端口（如果需要）
# Expose port (if needed)
EXPOSE 8080

# 设置Docker环境标识
# Set Docker environment flags
ENV DOCKER_CONTAINER=true
ENV RUN_MODE=scheduler

# 默认命令
# Default command
CMD ["python", "docker_run.py"]
