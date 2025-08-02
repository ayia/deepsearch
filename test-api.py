#!/usr/bin/env python3
"""
Script de test pour l'API Perplexica avec DeepSeek
Utilisez ce script pour tester l'API de chat
"""

import requests
import json
import uuid
from datetime import datetime

BASE_URL = "http://localhost:3000"

def test_config_api():
    """Test de l'API de configuration"""
    print("🔧 Test de l'API de configuration...")
    try:
        response = requests.get(f"{BASE_URL}/api/config")
        if response.status_code == 200:
            config = response.json()
            print("✅ Configuration récupérée:")
            print(json.dumps(config, indent=2, ensure_ascii=False))
        else:
            print(f"❌ Erreur: {response.status_code}")
    except Exception as e:
        print(f"❌ Erreur: {e}")

def test_chat_api(message):
    """Test de l'API de chat"""
    print(f"💬 Test de l'API de chat avec: {message}")
    
    chat_id = f"test-chat-{datetime.now().strftime('%Y%m%d-%H%M%S')}"
    message_id = f"msg-{uuid.uuid4().hex[:8]}"
    
    payload = {
        "message": {
            "messageId": message_id,
            "chatId": chat_id,
            "content": message
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
    
    try:
        response = requests.post(
            f"{BASE_URL}/api/chat",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            print("✅ Réponse reçue:")
            # L'API retourne un stream, on affiche les premières lignes
            content = response.text
            print(content[:500] + "..." if len(content) > 500 else content)
        else:
            print(f"❌ Erreur {response.status_code}: {response.text}")
    except Exception as e:
        print(f"❌ Erreur: {e}")

def test_search_api(query):
    """Test de l'API de recherche"""
    print(f"🔍 Test de l'API de recherche avec: {query}")
    
    payload = {
        "query": query,
        "focusMode": "webSearch"
    }
    
    try:
        response = requests.post(
            f"{BASE_URL}/api/search",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            results = response.json()
            print("✅ Résultats de recherche:")
            print(json.dumps(results, indent=2, ensure_ascii=False))
        else:
            print(f"❌ Erreur {response.status_code}: {response.text}")
    except Exception as e:
        print(f"❌ Erreur: {e}")

def main():
    """Menu principal"""
    while True:
        print("\n" + "="*50)
        print("🚀 Test API Perplexica avec DeepSeek")
        print("="*50)
        print("1. Tester l'API de configuration")
        print("2. Tester l'API de chat")
        print("3. Tester l'API de recherche")
        print("4. Quitter")
        print("-"*50)
        
        choice = input("Choisissez une option (1-4): ").strip()
        
        if choice == "1":
            test_config_api()
        elif choice == "2":
            message = input("Entrez votre message: ").strip()
            if message:
                test_chat_api(message)
            else:
                print("❌ Message vide!")
        elif choice == "3":
            query = input("Entrez votre requête de recherche: ").strip()
            if query:
                test_search_api(query)
            else:
                print("❌ Requête vide!")
        elif choice == "4":
            print("👋 Au revoir!")
            break
        else:
            print("❌ Option invalide!")
        
        input("\nAppuyez sur Entrée pour continuer...")

if __name__ == "__main__":
    main() 