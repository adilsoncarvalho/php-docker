FROM php:7.1.4-fpm

RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN echo "Acquire::Check-Valid-Until \"false\";" > /etc/apt/apt.conf.d/99-dont-check-validity

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      wget apt-transport-https ca-certificates libpcre3-dev gnupg

# NewRelic
# ENV DEBIAN_FRONTEND=noninteractive
RUN curl https://download.newrelic.com/548C16BF.gpg | apt-key add -
RUN echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list

# PHP DEB.SURY.CZ ##########################################################
RUN curl https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        zlibc \
        zlib1g \
        zlib1g-dev \
        php7.1-curl \
        php7.1-imagick \
        php7.1-mbstring \
        php7.1-mcrypt \
        php7.1-dev git pkg-config build-essential libmemcached-dev \
        php7.1-mysql \
        php7.1-pdo \
        php7.1-sqlite3 \
        newrelic-php5 \
        nginx

RUN cd ~ && \
    git clone https://github.com/php-memcached-dev/php-memcached.git && \
    cd php-memcached && \
    git checkout php7 && \
    phpize && \
    ./configure --disable-memcached-sasl && \
    make && \
    make install && \
    cd ~ && \
    rm -rf ~/php-memcached

COPY newrelic-boot-setup.sh /usr/local/sbin/newrelic-boot-setup.sh
RUN chmod +x /usr/local/sbin/newrelic-boot-setup.sh

RUN docker-php-ext-configure mbstring
RUN docker-php-ext-install mbstring zip
RUN docker-php-ext-install pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer global require --prefer-dist "fxp/composer-asset-plugin:~1.0"
