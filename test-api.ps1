# Script de test pour l'API Perplexica avec DeepSeek
# Utilisez ce script pour tester l'API de chat

$baseUrl = "http://localhost:3000"

# Fonction pour tester l'API de chat
function Test-ChatAPI {
    param(
        [string]$Message,
        [string]$ChatId = "test-chat-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    )
    
    $body = @{
        message = @{
            messageId = "msg-$(Get-Random)"
            chatId = $ChatId
            content = $Message
        }
        optimizationMode = "balanced"
        focusMode = "webSearch"
        history = @()
        files = @()
        chatModel = @{
            provider = "deepseek"
            name = "deepseek-chat"
        }
        embeddingModel = @{
            provider = "transformers"
            name = "xenova-bge-small-en-v1.5"
        }
        systemInstructions = "Tu es un assistant IA utile et intelligent."
    } | ConvertTo-Json -Depth 10
    
    Write-Host "Envoi de la requête à l'API..." -ForegroundColor Green
    Write-Host "Message: $Message" -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/chat" -Method POST -ContentType "application/json" -Body $body
        Write-Host "Réponse reçue:" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 5
    }
    catch {
        Write-Host "Erreur lors de l'appel API:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# Fonction pour tester l'API de configuration
function Test-ConfigAPI {
    Write-Host "Test de l'API de configuration..." -ForegroundColor Green
    try {
        $config = Invoke-RestMethod -Uri "$baseUrl/api/config" -Method GET
        Write-Host "Configuration:" -ForegroundColor Green
        $config | ConvertTo-Json -Depth 3
    }
    catch {
        Write-Host "Erreur lors de la récupération de la configuration:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Fonction pour tester l'API de recherche
function Test-SearchAPI {
    param([string]$Query)
    
    $body = @{
        query = $Query
        focusMode = "webSearch"
    } | ConvertTo-Json
    
    Write-Host "Test de l'API de recherche..." -ForegroundColor Green
    Write-Host "Requête: $Query" -ForegroundColor Yellow
    
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/api/search" -Method POST -ContentType "application/json" -Body $body
        Write-Host "Résultats de recherche:" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 3
    }
    catch {
        Write-Host "Erreur lors de la recherche:" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
}

# Menu principal
function Show-Menu {
    Clear-Host
    Write-Host "=== Test API Perplexica ===" -ForegroundColor Cyan
    Write-Host "1. Tester l'API de configuration" -ForegroundColor White
    Write-Host "2. Tester l'API de chat" -ForegroundColor White
    Write-Host "3. Tester l'API de recherche" -ForegroundColor White
    Write-Host "4. Quitter" -ForegroundColor White
    Write-Host ""
}

# Boucle principale
do {
    Show-Menu
    $choice = Read-Host "Choisissez une option (1-4)"
    
    switch ($choice) {
        "1" {
            Test-ConfigAPI
            Read-Host "Appuyez sur Entrée pour continuer"
        }
        "2" {
            $message = Read-Host "Entrez votre message"
            Test-ChatAPI -Message $message
            Read-Host "Appuyez sur Entrée pour continuer"
        }
        "3" {
            $query = Read-Host "Entrez votre requête de recherche"
            Test-SearchAPI -Query $query
            Read-Host "Appuyez sur Entrée pour continuer"
        }
        "4" {
            Write-Host "Au revoir!" -ForegroundColor Green
            break
        }
        default {
            Write-Host "Option invalide" -ForegroundColor Red
            Read-Host "Appuyez sur Entrée pour continuer"
        }
    }
} while ($choice -ne "4") 