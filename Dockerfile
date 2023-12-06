FROM richarvey/nginx-php-fpm:2.0.0

COPY composer.json composer.lock /var/www/html/

WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
      build-essential \
      libpng-dev \
      libjpeg62-turbo-dev \
      libfreetype6-dev \
      locales \
      zip \
      jpegoptim optipng pngquant gifsicle \
      vim \
      unzip \
      git \
      curl \
      libonig-dev \
      libzip-dev \
      libgd-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-configure gd --with-external-gd --with-freetype --with-jpeg \
      && docker-php-ext-install pdo_mysql mbstring zip exif bcmath pcntl gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www


# Set ownership and permissions
RUN chown -R www:www /var/www/html \
      && chmod -R 755 /var/www/html

# Copy existing application directory permissions
COPY --chown=www:www . .

# Change current user to www
USER www

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV SESSION_DRIVER=cookie
ENV CACHE_DRIVER=array

# Allow composer to run as root
# ENV COMPOSER_ALLOW_SUPERUSER 1

CMD ["/start.sh"]
