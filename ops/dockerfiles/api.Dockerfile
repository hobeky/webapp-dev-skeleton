# syntax=docker/dockerfile:1.7

########################
# Base PHP 8.3 image
########################
FROM php:8.3-fpm-alpine AS base
WORKDIR /var/www/html

# System dependencies
RUN apk add --no-cache \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    mariadb-connector-c-dev \
    bash \
    git \
    shadow \
    curl \
    unzip \
    wget \
    tzdata \
    nano \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev

# PHP extensions:
# - intl needs icu-dev
# - pdo_mysql works with MariaDB/MySQL
# - gd needs freetype/jpeg/png dev packages
# - zip needs libzip-dev
RUN docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" intl pdo_mysql opcache gd zip

# Install Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony \
    && chmod +x /usr/local/bin/symfony

# Opcache defaults
RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.validate_timestamps=1"; \
    echo "opcache.revalidate_freq=0"; \
} > /usr/local/etc/php/conf.d/opcache.ini


########################
# Dev image (with Xdebug)
########################
FROM base AS dev

# Install Xdebug compatible with PHP 8.3
RUN apk add --no-cache $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug || true

ENV XDEBUG_MODE=off