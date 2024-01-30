# Use the official PHP image
 FROM php:8.0-apache

 # Set working directory
 WORKDIR /var/www/html

 # Install dependencies
 RUN apt-get update && \
     apt-get install -y \
     libzip-dev \
     unzip \
     && docker-php-ext-install pdo_mysql zip

 # Copy Laravel files
 COPY . .

 # Set permissions
 RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
 RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

 # Expose Laravel API port
 EXPOSE 80

 # Start Apache
 CMD ["apache2-foreground"]