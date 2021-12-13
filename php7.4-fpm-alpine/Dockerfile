FROM php:7.4-fpm-alpine

RUN apk add --no-cache bash sudo imagemagick \
    && apk add --no-cache --virtual .build-deps ${PHPIZE_DEPS} tzdata imagemagick-dev icu-dev libzip-dev libxml2-dev freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
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
    && docker-php-ext-install -j$(nproc) pdo_mysql exif gd bcmath intl zip soap \
    # Install runtime dependencies
    && RUNTIME_DEPS="$(scanelf --needed --nobanner --recursive /usr/local | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' | sort -u | xargs -r apk info --installed | sort -u)" \
    && apk add --no-cache --virtual .runtime-deps ${RUNTIME_DEPS} \
    # Cleanup build dependencies
    && apk del .build-deps \
    && rm -r /tmp/*

COPY php-tweaks.ini /usr/local/etc/php/conf.d/