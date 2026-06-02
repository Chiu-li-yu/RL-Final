import os
api_key = os.getenv('GEMINI_API_KEY', 'NOT SET')
print(f"API Key: {api_key[:20]}..." if api_key != 'NOT SET' else f"API Key: {api_key}")
