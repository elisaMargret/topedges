FROM richarvey/nginx-php-fpm:2.0.0


# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Copy only the necessary files for dependency installation
COPY composer.json composer.lock /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apk update
# RUN composer install --no-dev --optimize-autoloader

# Add user for Laravel application
RUN addgroup -g 1000 www \
    && adduser -u 1000 -G www -s /bin/sh -D www

# Set ownership and permissions
RUN chown -R www:www /var/www/html \
    && chmod -R 755 /var/www/html

# Copy the rest of the application files
COPY --chown=www:www . .

# Change current user to www
USER www

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

CMD ["/start.sh"]
