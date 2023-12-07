FROM richarvey/nginx-php-fpm:2.0.0

WORKDIR /var/www/html

# Copy only the necessary files for dependency installation
COPY composer.json composer.lock /var/www/html/

# Install dependencies
RUN apk update && apk add --no-cache \
    build-base \
    locales \
    zip \
    unzip \
    && composer install --no-dev --optimize-autoloader

# Add user for Laravel application
RUN addgroup -g 1000 www \
    && adduser -u 1000 -G www -s /bin/sh -D www

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Set ownership and permissions
RUN chown -R www:www /var/www/html \
    && chmod -R 755 /var/www/html

# Copy the rest of the application files
COPY --chown=www:www . .

# Change current user to www
USER www

CMD ["/start.sh"]
