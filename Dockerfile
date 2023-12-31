FROM richarvey/nginx-php-fpm:2.0.0

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1


# Copy only the necessary files for dependency installation
COPY composer.json composer.lock /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apk update

# Enable extensions
RUN docker-php-ext-install \
    exif \
    intl \
    mysqli \
    pdo_mysql \
    pdo_pgsql \
    pgsql


RUN composer install --ignore-platform-req=ext-gd

COPY . .


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
