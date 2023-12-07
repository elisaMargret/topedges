#!/usr/bin/env bash
echo "Running composer"
composer install --no-dev --optimize-autoloader --ignore-platform-req=ext-gd

echo "generating application key..."
php artisan key:generate --show

echo "optimize clear"
php artisan optimize:clear

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Running migrations..."
php artisan migrate --force

# echo "Running db:seed"
# php artisan db:seed