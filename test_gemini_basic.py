"""
初期測試：Gemini function calling 簡單驗證

執行方式：
  source .venv/bin/activate
  export GEMINI_API_KEY="你的key"
  python test_gemini_basic.py
"""

from google import genai
from dotenv import load_dotenv
import os
import json

load_dotenv()

# 初始化 Gemini client
client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

# 定義兩個簡單的 tools，用來測試 function calling
tools = [
    {
        "name": "add",
        "description": "Add two numbers",
        "parameters": {
            "type": "object",
            "properties": {
                "a": {"type": "number"},
                "b": {"type": "number"},
            },
            "required": ["a", "b"],
        },
    },
    {
        "name": "multiply",
        "description": "Multiply two numbers",
        "parameters": {
            "type": "object",
            "properties": {
                "a": {"type": "number"},
                "b": {"type": "number"},
            },
            "required": ["a", "b"],
        },
    },
]

# 開始對話
print("=== Gemini Function Calling 測試 ===\n")

model = client.models.generate_content(
    "2 + 3 是多少？用 add 工具計算。",
    tools=tools,
)

print(f"Gemini 回應：\n{model.content}")
print("\n✅ Function calling 正常運作")
