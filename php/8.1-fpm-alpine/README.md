This base image is based on `php:8.1-fpm-alpine`.

# Configuration
- Local time and time zone is set to `Europe/Amsterdam`
- Optimized opcache and php config
- Locals (via https://gitlab.com/rilian-la-te/musl-locales)
  - C
  - C.UTF-8
  - es_ES.UTF-8
  - ru_RU.UTF-8
  - de_CH.UTF-8
  - nb_NO.UTF-8
  - pt_BR.UTF-8
  - de_DE.UTF-8
  - fr_FR.UTF-8
  - en_GB.UTF-8
  - sv_SE.UTF-8
  - en_US.UTF-8
  - nl_NL.UTF-8
  - it_IT.UTF-8
  - ch_DE.UTF-8

# Extra installed packages and extensions
- bash
- composer
- imagick
- pdo_mysql
- exif
- gd