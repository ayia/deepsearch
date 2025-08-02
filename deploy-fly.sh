#!/bin/bash

# Script de déploiement Perplexica sur Fly.io
echo "🚀 Déploiement de Perplexica sur Fly.io..."

# Vérifier si flyctl est installé
if ! command -v flyctl &> /dev/null; then
    echo "❌ flyctl n'est pas installé. Veuillez l'installer depuis https://fly.io/docs/hands-on/install-flyctl/"
    exit 1
fi

# Vérifier si l'utilisateur est connecté
if ! flyctl auth whoami &> /dev/null; then
    echo "🔐 Connexion à Fly.io..."
    flyctl auth login
fi

# Créer l'application si elle n'existe pas
echo "📦 Création de l'application Fly.io..."
flyctl apps create perplexica --org personal || echo "L'application existe déjà"

# Créer les volumes persistants
echo "💾 Création des volumes persistants..."
flyctl volumes create perplexica_data --size 1 --region cdg || echo "Le volume data existe déjà"
flyctl volumes create perplexica_uploads --size 1 --region cdg || echo "Le volume uploads existe déjà"

# Déployer l'application
echo "🚀 Déploiement de l'application..."
flyctl deploy

# Ouvrir l'application
echo "🌐 Ouverture de l'application..."
flyctl open

echo "✅ Déploiement terminé !"
echo "🔗 Votre application est disponible à: https://perplexica.fly.dev"
echo ""
echo "📝 Notes importantes:"
echo "1. Configurez vos clés API dans l'interface web"
echo "2. Pour SearXNG, vous devrez déployer une instance séparée ou utiliser une instance publique"
echo "3. Mettez à jour l'URL SearXNG dans les paramètres de l'application" 