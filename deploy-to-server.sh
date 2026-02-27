#!/bin/bash

# Configuration
SERVER_USER="polo"
SERVER_IP=""
DEST_DIR="~/*-deploy"

echo "🚀 Starting deployment to $SERVER_IP..."

# 1. Sync files to the server (excluding node_modules and git)
rsync -avz --exclude 'node_modules' --exclude '.git' --exclude 'dist' \
      ./ $SERVER_USER@$SERVER_IP:$DEST_DIR

# 2. Run Docker commands on the server via SSH
ssh $SERVER_USER@$SERVER_IP << 'EOF'
  cd ~/file-manager-deploy

  docker network inspect global-infra >/dev/null 2>&1 || \
    docker network create global-infra

  docker compose down
  docker compose up --build -d
  docker image prune -f

  echo "✅ Deployment successful!"
EOF
