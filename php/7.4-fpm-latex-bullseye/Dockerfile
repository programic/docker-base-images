FROM php:7.4-fpm-bullseye

# Persistent dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    cron aspell aspell-nl aspell-en \
    # Java
    default-jdk \
    # Latex
    texlive-fonts-extra texlive-lang-european texlive-lang-english texlive-luatex texlive-pstricks texlive-publishers texlive-science texlive-xetex \
    # Cleanup
    && rm -rf /var/lib/apt/lists/*

RUN savedAptMark="$(apt-mark showmanual)" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    libzip-dev libfreetype6-dev libmagickwand-dev libjpeg-dev libpng-dev libwebp-dev libpspell-dev \
    # Config timezone
    && ln -snf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime \
    && echo "Europe/Amsterdam" > /etc/timezone \
    # Install composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    # Install the imagick php extension via pecl
    && pecl install imagick redis \
    && docker-php-ext-enable imagick redis \
    # Config imagick
    && sed -i -e 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' /etc/ImageMagick-6/policy.xml \
    # Config gd
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    # Install php extensions. Speedup by using -j
    && docker-php-ext-install -j$(nproc) pdo_mysql exif gd bcmath intl zip soap \
    # Reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    && apt-mark auto '.*' > /dev/null \
    && apt-mark manual $savedAptMark \
    && ldd "$extDir"/*.so | awk '/=>/ { print $3 }' | sort -u | xargs -r dpkg-query -S | cut -d: -f1 | sort -u | xargs -rt apt-mark manual \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && rm -r /tmp/pear

# Config Latex
COPY xelatex-quiet.sh /usr/local/bin/xelatex-quiet

RUN echo "buf_size = 5000000" >> /etc/texmf/texmf.d/00debian.cnf \
    && update-texmf \
    && chmod +x /usr/local/bin/xelatex-quiet
