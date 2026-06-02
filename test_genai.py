#!/usr/bin/env python3
import sys
import os

# 先執行 monkey patch
sys.path.insert(0, '/app')
import agent.agent

# 測試 genai 連接
import google.genai as genai

api_key = os.getenv('GEMINI_API_KEY')
print(f"API Key: {api_key[:20]}..." if api_key else "API Key: NOT SET")

try:
    client = genai.Client(api_key=api_key)
    print("✓ Client created")

    # 嘗試簡單的調用
    response = client.models.list()
    print("✓ API call successful")
    print(f"Available models: {len(list(response))}")
except Exception as e:
    print(f"✗ Error: {type(e).__name__}: {e}")
    import traceback
    traceback.print_exc()
