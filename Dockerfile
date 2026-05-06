# Use official PHP image
FROM php:8.3-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    postgresql-dev \
    git \
    curl \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /app

# Copy composer files
COPY composer.json composer.lock* ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts

# Copy application
COPY . .

# Run Symfony scripts after application files are present
RUN composer run-script post-install-cmd --no-interaction

# Set permissions
RUN chmod +x bin/console && \
    mkdir -p var/cache var/log && \
    chown -R www-data:www-data var/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD php -r "echo 'OK';"

EXPOSE 9000

USER www-data

CMD ["php-fpm"]
