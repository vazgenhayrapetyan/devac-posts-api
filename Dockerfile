FROM php:8.3-fpm-alpine

# 1. Տեղադրում ենք համակարգային գործիքները
RUN apk update && apk add --no-cache curl libpng-dev libxml2-dev libzip-dev zip unzip git

# 2. Տեղադրում ենք PHP extensions-ը
RUN docker-php-ext-install pdo_mysql bcmath zip

# 3. Տեղադրում ենք Composer-ը
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
ENV COMPOSER_ALLOW_SUPERUSER=1

# 4. Պատճենում ենք ձեր լոկալ աշխատող կոդի ֆայլերը
COPY . .

# 5. Տեղադրում ենք package-ները
RUN composer install --no-dev --optimize-autoloader --no-scripts --ignore-platform-reqs --no-interaction

# 6. Տրամադրում ենք թույլտվություններ storage թղթապանակին
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80

# 7. ԱՄԵՆԱԿԱՐԵՎՈՐ ՏՈՂԸ. Ստարտի ժամանակ ավտոմատ աշխատեցնում ենք Միգրացիան և ձեր UserSeeder-ը
CMD php artisan migrate --force && php artisan db:seed --class=UserSeeder --force && php artisan serve --host=0.0.0.0 --port=80
