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

mysql -h mysql -u root -proot -e "CREATE DATABASE IF NOT EXISTS lostcity_market;"


TABLE_COUNT=$(mysql -h mysql -u root -proot -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='lostcity_market';")

if [ "$TABLE_COUNT" -eq 0 ]; then
  echo "Database is empty. Running migrations and seeders..."
  php artisan migrate:fresh --seed
else
  echo "Database already initialized. Skipping migrations."
fi