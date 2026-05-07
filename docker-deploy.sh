#!/bin/bash

set -e

echo "🚀 Starting Proinvestment Docker Compose deployment..."

COMPOSE="docker compose --env-file .env.local -f compose.yaml"

# Copy environment file if it doesn't exist
if [ ! -f .env.local ]; then
    echo "📋 Creating .env.local from .env.docker..."
    cp .env.docker .env.local
    echo "⚠️  UPDATE .env.local with your production secrets before running!"
fi

# Build images
echo "🔨 Building Docker images..."
$COMPOSE build

# Start services
echo "🐳 Starting services..."
$COMPOSE up -d

# Wait for database to be healthy
echo "⏳ Waiting for database to be ready..."
sleep 10

# Run migrations
echo "🗄️  Running database migrations..."
$COMPOSE exec -T web php bin/console doctrine:database:create --if-not-exists
$COMPOSE exec -T web php bin/console doctrine:migrations:migrate --no-interaction

# Clear cache
echo "🧹 Clearing cache..."
$COMPOSE exec -T web php bin/console cache:clear

echo "✅ Deployment complete!"
echo ""
echo "📍 Services running at:"
echo "  - Web: http://localhost"
echo "  - Mailpit: http://localhost:8025"
echo ""
echo "📝 Next steps:"
echo "  1. Update .env.local with your production secrets"
echo "  2. Run: docker compose --env-file .env.local -f compose.yaml restart web"
echo "  3. Check logs: docker compose --env-file .env.local -f compose.yaml logs -f web"
