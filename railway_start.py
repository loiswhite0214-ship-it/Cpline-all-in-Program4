#!/usr/bin/env python3
"""Railway 启动脚本：绑定 $PORT 与 0.0.0.0，直接运行 dashboard.py"""

import os
import sys
import subprocess
import pathlib

ROOT = pathlib.Path(__file__).resolve().parent
APP = ROOT / "dashboard.py"

PORT = os.getenv("PORT", "8080")

env = os.environ.copy()
env["STREAMLIT_SERVER_HEADLESS"] = "true"
env["PYTHONUNBUFFERED"] = "1"

def main() -> None:
    if not APP.exists():
        print(f"❌ 应用文件不存在: {APP}")
        sys.exit(1)

    cmd = [
        sys.executable, "-u", "-m", "streamlit", "run", str(APP),
        "--server.port", str(PORT),
        "--server.address", "0.0.0.0",
        "--browser.gatherUsageStats", "false",
    ]

    print("=" * 50)
    print("🚀 Railway 加密货币交易监控面板")
    print("=" * 50)
    print(f"🔌 使用端口: {PORT}")
    print(f"📄 使用应用文件: {APP}")
    print(f"🚀 启动命令: {' '.join(cmd)}")

    subprocess.run(cmd, check=True, env=env)

if __name__ == "__main__":
    main()
