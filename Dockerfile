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

# 建立虛擬環境
RUN uv venv .venv

# 設定環境變數使虛擬環境為預設
ENV PATH="/app/.venv/bin:$PATH"
ENV VIRTUAL_ENV="/app/.venv"

# 在虛擬環境中安裝依賴
RUN uv pip install --no-cache -r requirements.txt

# 複製專案檔案
COPY . .

# outputs 目錄掛載點（執行時用 -v 將結果持久化到本機）
VOLUME ["/app/outputs"]

CMD ["python3", "run.py"]
