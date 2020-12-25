FROM php:7.2.6-fpm
LABEL maintainer="lianbo.wan@gmail.com"

ENV PHPREDIS_VERSION 5.2.1
ENV PHPSWOOLE_VERSION 4.4.17
ENV PHPIMAGEMAGICK_VERSION 7.0.10-19

# 修改镜像源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
    && sed -i "s@http://deb.debian.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
    && sed -i "s@security.debian.org/debian-security@mirrors.aliyun.com/debian-security@g" /etc/apt/sources.list \
    #adiscon rsyslog源
    && echo "deb http://ppa.launchpad.net/adiscon/v8-devel/ubuntu xenial main/debug" > /etc/apt/sources.list.d/adiscon-ubuntu-v8-devel-xenial.list \
    && cat /etc/apt/sources.list \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    #&& apt-get update -y \
    && apt-get update -o Acquire::CompressionTypes::Order::=gz

# Install PHP extensions and PECL modules.
COPY wkhtmltox.tar.xz ImageMagick.tar.gz extension/* ./

RUN buildDeps=" \
        default-libmysqlclient-dev \
        libbz2-dev \
        libsasl2-dev \
        libxslt-dev \
    " \
    runtimeDeps=" \
        libmagickwand-dev \
        libmagickcore-dev \
        rsyslog \
        cron \
        vim \
        curl \
        git \
        procps \
        supervisor \
        zip \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libzip-dev \
        libwebp-dev \
        libxext6 \
        libxrender1 \
        libfontconfig1 \
    " \
    # 扩展安装方式 一.pecl安装，如果pecl被墙，为pecl设置代理
    #&& pear config-set http_proxy http://10.0.10.7:1080 \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps --no-install-recommends \
    # 二.从网上下载手动安装
    #&& curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    #&& curl -L -o /tmp/swoole.tar.gz https://github.com/swoole/swoole-src/archive/v$PHPSWOOLE_VERSION.tar.gz \
    && cp phpredis-$PHPREDIS_VERSION.tar.gz /tmp/redis.tar.gz \
    && cp swoole-src-$PHPSWOOLE_VERSION.tar.gz /tmp/swoole.tar.gz \
    && mkdir -p /usr/src/php/ext \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && tar xfz /tmp/swoole.tar.gz \
    && rm -r /tmp/swoole.tar.gz \
    && mv swoole-src-$PHPSWOOLE_VERSION /usr/src/php/ext/swoole \
    && docker-php-ext-install swoole \
    && docker-php-ext-install bcmath bz2 calendar intl mysqli opcache pdo_mysql pdo_pgsql shmop soap sockets sysvsem pcntl xmlrpc xsl exif \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip \
    && docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    && docker-php-ext-install gd \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone \
    && tar -xvf wkhtmltox.tar.xz \
    && cp wkhtmltox/bin/wkhtmlto* /usr/bin/ \
    && rm -rf wkhtmltox wkhtmltox.tar.xz \
    && tar xfz ImageMagick.tar.gz \
    && cd ImageMagick-$PHPIMAGEMAGICK_VERSION && ./configure && make && make install && ldconfig /usr/local/lib \
    #&& apt-get purge -y --auto-remove $buildDeps \
    && rm -r /var/lib/apt/lists/*

# Install Composer.
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    #&& ln -s $(composer config --global home) /root/composer
#ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

COPY ./supervisord.conf /etc/supervisor
COPY ./SimSun.ttf /usr/share/fonts/truetype/
COPY ./www.conf /usr/local/etc/php-fpm.d/
COPY ./php.ini /usr/local/etc/php/conf.d/
COPY ./start_php.sh /root/start_php.sh
COPY ./crontab.sh /root/crontab.sh
COPY ./rsyslog.sh /root/rsyslog.sh
ENV APP_FILE  /root/start_php.sh

#CMD ["/usr/bin/supervisord"]
CMD $APP_FILE
