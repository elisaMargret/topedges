FROM richarvey/nginx-php-fpm:2.0.0

# Copy only the necessary files for dependency installation
COPY composer.json composer.lock /var/www/html/

# Set working directory
WORKDIR /var/www/html


# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN apk update \
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
