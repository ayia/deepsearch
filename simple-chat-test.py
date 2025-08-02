#!/usr/bin/env python3
"""
Test simple de l'API de chat Perplexica avec DeepSeek
"""

import requests
import json
import uuid
from datetime import datetime

BASE_URL = "http://localhost:3000"

def test_chat():
    """Test simple de l'API de chat"""
    
    chat_id = f"test-chat-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
    message_id = f"msg-{uuid.uuid4().hex[:8]}"
    
    payload = {
        "message": {
            "messageId": message_id,
            "chatId": chat_id,
            "content": "Bonjour, comment ça va ?"
        },
        "optimizationMode": "balanced",
        "focusMode": "webSearch",
        "history": [],
        "files": [],
        "chatModel": {
            "provider": "deepseek",
            "name": "deepseek-chat"
        },
        "embeddingModel": {
            "provider": "transformers",
            "name": "xenova-bge-small-en-v1.5"
        },
        "systemInstructions": "Tu es un assistant IA utile et intelligent."
    }
    
    print("🚀 Test de l'API de chat...")
    print(f"URL: {BASE_URL}/api/chat")
    print(f"Payload: {json.dumps(payload, indent=2, ensure_ascii=False)}")
    
    try:
        response = requests.post(
            f"{BASE_URL}/api/chat",
            json=payload,
            headers={"Content-Type": "application/json"},
            timeout=30
        )
        
        print(f"\n📊 Status Code: {response.status_code}")
        print(f"📊 Headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            print("✅ Réponse reçue:")
            content = response.text
            print(content[:1000] + "..." if len(content) > 1000 else content)
        else:
            print(f"❌ Erreur {response.status_code}:")
            print(response.text)
            
    except Exception as e:
        print(f"❌ Erreur: {e}")

if __name__ == "__main__":
    test_chat() 