FROM php:8.1-fpm-alpine

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

RUN apk add --no-cache bash imagemagick \
    && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} tzdata imagemagick-dev libzip-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev libxml2-dev \
    # Change localtime and timezone
    && cp /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime \
    && echo "Europe/Amsterdam" > /etc/timezone \
    # Install composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    # Install the imagick php extension via pecl
    && pecl install imagick redis \
    && docker-php-ext-enable imagick redis \
    # Config gd
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    # Install php extensions. Speedup by using -j
    && docker-php-ext-install -j$(nproc) pdo_mysql exif gd zip opcache soap \
    # Install runtime dependencies
    && runtime_deps="$(scanelf --needed --nobanner --recursive /usr/local | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | sort -u | xargs -r apk info --installed | sort -u)" \
    && apk add --no-cache --virtual .runtime-deps ${runtime_deps} \
    # Cleanup build dependencies
    && apk del .build-deps \
    && rm -r /tmp/*

COPY php-tweaks.ini /usr/local/etc/php/conf.d/