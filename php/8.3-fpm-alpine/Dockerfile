FROM php:8.3-fpm-alpine

ENV MUSL_LOCPATH /usr/share/i18n/locales/musl
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS 0
ENV PHP_MEMORY_LIMIT 512M
ENV COMPOSER_ALLOW_SUPERUSER 1

# Installing locals, tutorial: https://grrr.tech/posts/2020/add-locales-to-alpine-linux-docker-image/
RUN apk add --no-cache --virtual .build-musl cmake make musl-dev gcc gettext-dev libintl \
    && wget https://gitlab.com/rilian-la-te/musl-locales/-/archive/master/musl-locales-master.zip \
    && unzip musl-locales-master.zip \
    && (cd musl-locales-master && cmake -D LOCALE_PROFILE=OFF -D CMAKE_INSTALL_PREFIX:PATH=/usr . && make && make install) \
    && apk del .build-musl \
    && rm -r musl-locales-master

RUN apk add --no-cache bash git freetype libpng libjpeg-turbo libzip-dev ghostscript imagemagick jpegoptim optipng pngquant gifsicle libldap libpq less mysql-client \
    && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} autoconf gcc g++ imagemagick-dev libtool make tzdata imagemagick-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxml2-dev linux-headers icu-dev \
    # Change localtime and timezone
    && cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime \
    && echo "Europe/Amsterdam" > /etc/timezone \
    # Install composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && pecl install redis \
    && docker-php-ext-enable redis \
    # Install the imagick php extension via make \
    && git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick && cd /tmp/imagick && git fetch origin master && git switch master && cd /tmp/imagick \
    && phpize \
    && ./configure \
    && make && make install \
    && docker-php-ext-enable imagick \
    # Config gd
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    # Config pcntl
    && docker-php-ext-configure pcntl --enable-pcntl \
    # Install php extensions. Speedup by using -j
    && docker-php-ext-install -j$(nproc) pdo_mysql exif gd zip opcache soap intl pcntl sockets \
    # Install runtime dependencies
    && runtime_deps="$(scanelf --needed --nobanner --recursive /usr/local | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | sort -u | xargs -r apk info --installed | sort -u)" \
    && apk add --no-cache --virtual .runtime-deps ${runtime_deps} \
    # Cleanup build dependencies
    && apk del .build-deps \
    && rm -rf /tmp/*

COPY php-tweaks.ini /usr/local/etc/php/conf.d/
