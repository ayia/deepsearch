# 🚀 Déploiement de Perplexica sur Fly.io

Ce guide vous explique comment déployer Perplexica sur Fly.io avec une URL publique.

## Prérequis

1. **Compte Fly.io** : Créez un compte sur [fly.io](https://fly.io)
2. **flyctl CLI** : Installez l'outil de ligne de commande Fly.io
3. **Git** : Assurez-vous que votre projet est dans un dépôt Git

## Installation de flyctl

### Windows (PowerShell)
```powershell
iwr https://fly.io/install.ps1 -useb | iex
```

### macOS
```bash
curl -L https://fly.io/install.sh | sh
```

### Linux
```bash
curl -L https://fly.io/install.sh | sh
```

## Déploiement automatique

1. **Cloner le projet** (si ce n'est pas déjà fait) :
```bash
git clone https://github.com/ItzCrazyKns/Perplexica.git
cd Perplexica
```

2. **Rendre le script exécutable** :
```bash
chmod +x deploy-fly.sh
```

3. **Exécuter le script de déploiement** :
```bash
./deploy-fly.sh
```

## Déploiement manuel

Si vous préférez déployer manuellement :

1. **Se connecter à Fly.io** :
```bash
flyctl auth login
```

2. **Créer l'application** :
```bash
flyctl apps create perplexica --org personal
```

3. **Créer les volumes persistants** :
```bash
flyctl volumes create perplexica_data --size 1 --region cdg
flyctl volumes create perplexica_uploads --size 1 --region cdg
```

4. **Déployer l'application** :
```bash
flyctl deploy
```

5. **Ouvrir l'application** :
```bash
flyctl open
```

## Configuration post-déploiement

### 1. Configuration des API Keys

Après le déploiement, accédez à votre application et configurez vos clés API dans les paramètres :

- **OpenAI** : Pour utiliser GPT-4, GPT-3.5-turbo
- **Anthropic** : Pour utiliser Claude
- **Groq** : Pour utiliser les modèles Groq
- **Gemini** : Pour utiliser les modèles Google
- **Deepseek** : Pour utiliser les modèles Deepseek

### 2. Configuration de SearXNG

Perplexica nécessite une instance SearXNG pour fonctionner. Vous avez plusieurs options :

#### Option A : Instance SearXNG publique
Utilisez une instance SearXNG publique comme :
- `https://searx.be`
- `https://searx.tiekoetter.com`
- `https://search.brave.com/results`

#### Option B : Déployer SearXNG séparément
Créez un fichier `searxng-fly.toml` :

```toml
app = "perplexica-searxng"
primary_region = "cdg"

[build]
  image = "searxng/searxng:latest"

[env]
  PORT = "8080"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 0

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 512
```

Puis déployez :
```bash
flyctl deploy -f searxng-fly.toml
```

### 3. Mise à jour de l'URL SearXNG

Dans les paramètres de Perplexica, mettez à jour l'URL SearXNG avec votre instance.

## Variables d'environnement

Vous pouvez configurer des variables d'environnement via le dashboard Fly.io ou en ajoutant des secrets :

```bash
flyctl secrets set SEARXNG_API_URL="https://votre-instance-searxng.com"
```

## Monitoring et logs

- **Voir les logs** : `flyctl logs`
- **Statut de l'application** : `flyctl status`
- **Dashboard** : `flyctl dashboard`

## Mise à jour

Pour mettre à jour votre application :

```bash
git pull
flyctl deploy
```

## Dépannage

### Problèmes courants

1. **Erreur de build** : Vérifiez que tous les fichiers sont présents
2. **Erreur de connexion SearXNG** : Vérifiez l'URL dans les paramètres
3. **Erreur de volume** : Vérifiez que les volumes sont créés dans la bonne région

### Logs détaillés

```bash
flyctl logs --all
```

## Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs : `flyctl logs`
2. Consultez la documentation Fly.io
3. Ouvrez une issue sur GitHub

## Coûts

Fly.io propose un plan gratuit généreux :
- 3 machines partagées
- 3GB de stockage
- 160GB de bande passante

Pour plus d'informations : https://fly.io/docs/about/pricing/ 