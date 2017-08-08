FROM php:7.1.4-fpm

RUN apt-get update && apt-get dist-upgrade -y && \
    # DEPENDENCIES #############################################################
    apt-get install -y wget curl apt-transport-https ca-certificates libpcre3-dev && \
    # PHP DEB.SURY.CZ ##########################################################
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        zlibc \
        zlib1g \
        zlib1g-dev \
        php7.1-curl \
        php7.1-imagick \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-memcache \
        php7.1-mysql \
        php7.1-pdo \
        php7.1-sqlite3 \
        nginx

RUN docker-php-ext-configure mbstring
RUN docker-php-ext-install mbstring zip
RUN docker-php-ext-install pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer global require --prefer-dist "fxp/composer-asset-plugin:~1.0"

