FROM php:7-apache
ADD apache2.conf /etc/apache2/apache2.conf
ADD symfony.ini /usr/local/etc/php/conf.d/symfony.ini

RUN apt-get update \
        && apt-get install -y libicu-dev git zlib1g-dev\
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_mysql opcache intl && a2enmod rewrite
RUN docker-php-ext-install zip

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

RUN pecl install -f xdebug-2.4 \
    && pecl clear-cache \
    && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini

RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && chmod a+x /usr/local/bin/symfony