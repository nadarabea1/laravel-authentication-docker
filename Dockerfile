FROM php:8.0-apache

WORKDIR /var/www/html

COPY --chown=www-data:www-data . /var/www/html

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    && docker-php-ext-install zip pdo_mysql

RUN a2enmod rewrite

COPY site.conf /etc/apache2/sites-available/000-default.conf

ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

EXPOSE 80
CMD ["apache2-foreground"]
