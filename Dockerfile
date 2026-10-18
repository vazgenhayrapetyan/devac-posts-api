FROM php:8.4-fpm-alpine

# 1. Տեղադրում ենք համակարգային անհրաժեշտ գործիքները Linux-ում
RUN apk update && apk add --no-cache curl libpng-dev libxml2-dev libzip-dev zip unzip git

# 2. Տեղադրում ենք PHP extensions-ը MySQL-ի և Zip-ի համար
RUN docker-php-ext-install pdo_mysql bcmath zip

# 3. Տեղադրում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
ENV COMPOSER_ALLOW_SUPERUSER=1

# 4. Պատճենում ենք ձեր լոկալ պրոեկտի ֆայլերը
COPY . .

# 5. Տեղադրում ենք package-ները
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs --no-interaction

# 6. Տրամադրում ենք թույլտվություններ storage-ին
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

# 7. Ստարտի ժամանակ ավտոմատ կատարում ենք միգրացիան, Seeder-ը և միացնում սերվերը
CMD php artisan migrate --force && php artisan db:seed --class=UserSeeder --force && php artisan serve --host=0.0.0.0 --port=80
