FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    iverilog \
    yosys \
    python3 \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 確認 iverilog 版本（build log 用）
RUN iverilog -V 2>&1 | head -1

# 安裝 uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

# 先複製 requirements 安裝依賴（利用 Docker layer cache）
COPY requirements.txt .
RUN uv pip install --system --no-cache -r requirements.txt

# 複製專案檔案
COPY . .

# outputs 目錄掛載點（執行時用 -v 將結果持久化到本機）
VOLUME ["/app/outputs"]

# API key 在 docker run 時以 -e 傳入
ENV GEMINI_API_KEY=""

CMD ["python3", "run.py"]
