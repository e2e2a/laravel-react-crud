# Base image
FROM laravelphp/php-fpm-nginx-node:latest

# Set working directory
WORKDIR /var/www/html

# Copy all files
COPY . .

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Build front-end assets
RUN npm install && npm run build

# Generate app key and migrate
RUN php artisan key:generate && php artisan migrate --force

# Expose port for Laravel dev server (optional; not used in production)
EXPOSE 8000

# Start Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
