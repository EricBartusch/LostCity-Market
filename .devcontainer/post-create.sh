#!/bin/bash
set -e

cd /workspace  

git config --global --add safe.directory $(pwd)

npm install
composer install

cp .env.example .env

sed -i 's/^DB_USERNAME=.*/DB_USERNAME=root/' .env
sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=root/' .env
sed -i 's/^DB_HOST=.*/DB_HOST=mysql/' .env

php artisan key:generate

echo "Waiting for MySQL to be ready..."
until mysqladmin ping -h mysql -u root -proot --silent; do
  sleep 2
done

mysql -h mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS lostcity_markets;"

php artisan migrate:fresh --seed
