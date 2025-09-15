# Root-level Dockerfile to build app from repository (robust to layout)
FROM python:3.11-slim

# Install system deps
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy the entire repository into image
COPY . /app/

# Upgrade build tools
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Remove any vendored pandas_ta copies to avoid shadowing the installed package
RUN bash -lc 'rm -rf \
  /app/crypto-trading-dashboard/pandas_ta \
  /app/crypto-trading-dashboard/libs/pta_shim/pandas_ta \
  /app/crypto-trading-dashboard/libs/pta/Technical-Analysis-Indicators---Pandas-master/pandas_ta || true'

# Install Python dependencies (prefer binary wheels; keep root/subdir detection)
RUN bash -lc 'set -euo pipefail; \
  if [ -f requirements.txt ]; then \
    echo "Using root requirements.txt"; \
    python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir --prefer-binary -r requirements.txt; \
  elif [ -f crypto-trading-dashboard/requirements.txt ]; then \
    echo "Using subdir requirements.txt"; \
    python -m pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir --prefer-binary -r crypto-trading-dashboard/requirements.txt; \
  else \
    echo "No requirements.txt found" >&2; exit 1; \
  fi'

# Expose Railway expected port
EXPOSE 8080

# Start the app via Railway script
CMD ["python", "-u", "crypto-trading-dashboard/railway_start.py"]
