#!/usr/bin/env python3
import sys
import os

print("=== Debug Docker Environment ===", file=sys.stderr)
print(f"Python: {sys.version}", file=sys.stderr)
print(f"CWD: {os.getcwd()}", file=sys.stderr)

# 1. 檢查 API key
api_key = os.getenv('GEMINI_API_KEY')
print(f"\nAPI Key present: {bool(api_key)}", file=sys.stderr)
if api_key:
    print(f"API Key length: {len(api_key)}", file=sys.stderr)
    print(f"API Key format: {api_key[:15]}...", file=sys.stderr)

# 2. 檢查 monkey patch
print("\n=== Checking monkey patch ===", file=sys.stderr)
import httpx._models
original_func = httpx._models._normalize_header_value
print(f"Original function: {original_func}", file=sys.stderr)

# 3. 嘗試導入 google.genai
print("\n=== Importing google.genai ===", file=sys.stderr)
try:
    import google.genai as genai
    print(f"google-genai version: {genai.__version__}", file=sys.stderr)

    # 4. 創建 client
    print("\n=== Creating client ===", file=sys.stderr)
    client = genai.Client(api_key=api_key)
    print("Client created OK", file=sys.stderr)

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    import traceback
    traceback.print_exc(file=sys.stderr)

print("\n=== Done ===", file=sys.stderr)
