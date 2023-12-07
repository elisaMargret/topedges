FROM richarvey/nginx-php-fpm:2.0.0

COPY ./composer.json ./composer.lock /var/www/html/

RUN apk update

# Install dependencies
RUN apk update && apk add --no-cache \
    build-essential \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    libonig-dev \
    libzip-dev \
    libgd-dev

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Set ownership and permissions
RUN chown -R www:www /var/www/html \
    && chmod -R 755 /var/www/html

# Copy existing application directory permissions
COPY --chown=www:www . .

# Change current user to www
USER www


CMD ["/start.sh"]
