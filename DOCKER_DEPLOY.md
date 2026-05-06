# Docker Compose Deployment Guide

## Quick Start

### 1. **Setup Environment**
```bash
cp .env.docker .env.local
# Edit .env.local with your production secrets
```

### 2. **Deploy**
```bash
chmod +x docker-deploy.sh
./docker-deploy.sh
```

Or manually:
```bash
docker-compose build
docker-compose up -d
docker-compose exec web php bin/console doctrine:migrations:migrate
docker-compose exec web php bin/console cache:clear
```

## Services

- **web**: PHP-FPM (port 9000)
- **nginx**: Web server (port 80, 443)
- **database**: PostgreSQL (port 5432)
- **mailer**: Mailpit SMTP (ports 1025, 8025)

## Common Commands

```bash
# View logs
docker-compose logs -f web

# SSH into web container
docker-compose exec web bash

# Run console commands
docker-compose exec web php bin/console cache:clear
docker-compose exec web php bin/console assets:install

# Database backup
docker-compose exec database pg_dump -U app app > backup.sql

# Restart services
docker-compose restart

# Stop services
docker-compose down

# Remove volumes (⚠️ deletes data)
docker-compose down -v
```

## Production Deployment

### 1. **Security**
- Set strong `POSTGRES_PASSWORD` in `.env.local`
- Set `APP_SECRET` to a random value
- Use `APP_DEBUG=0`
- Add SSL certificates to `./certs/`

### 2. **Scale**
```bash
docker-compose up -d --scale web=3
```

### 3. **Backup**
```bash
docker-compose exec database pg_dump -U app app > backup.sql
```

### 4. **Health Check**
```bash
curl http://localhost/
docker-compose ps
```
