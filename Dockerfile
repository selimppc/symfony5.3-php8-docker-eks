# ARG
ARG PHP_VERSION=8.0.11
ARG FPM_ALPINE_VERSION=3.14
ARG TIMEZONE=UTC

# "php" stage
FROM php:${PHP_VERSION}-fpm-alpine${FPM_ALPINE_VERSION} AS symfony5_php8
MAINTAINER Selim Reza <selimppc@gmail.com>

# persistent / runtime deps
RUN apk add --no-cache \
		acl \
		fcgi \
		file \
		gettext \
		git \
		gnu-libiconv \
	;

# install gnu-libiconv and set LD_PRELOAD env to make iconv work fully on Alpine image.
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so

ARG APCU_VERSION=5.1.20
RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
		icu-dev \
		libzip-dev \
		zlib-dev \
	; \
	\
	docker-php-ext-configure zip; \
	docker-php-ext-install -j$(nproc) \
		intl \
		zip \
	; \
	pecl install \
		apcu-${APCU_VERSION} \
	; \
	pecl clear-cache; \
	docker-php-ext-enable \
		apcu \
		opcache \
	; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .phpexts-rundeps $runDeps; \
	\
	apk del .build-deps

COPY docker/docker-healthcheck.sh /docker-healthcheck.sh
RUN chmod +x /docker-healthcheck.sh

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["/docker-healthcheck.sh"]

RUN ln -s $PHP_INI_DIR/php.ini-production $PHP_INI_DIR/php.ini
COPY docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

#nginx config
# Removing default nginx conf file
RUN rm -rf /etc/nginx/conf.d/default.conf
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf

#volume
VOLUME /var/run/php
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

# Installing required packages
#RUN apk add --no-cache \
RUN apk add \
  $PHPIZE_DEPS bash unzip bind-tools libpng-dev fcgi libxml2-dev \
  libmcrypt-dev gcc wget curl-dev curl openssl nginx iproute2 \
  vim icu-dev \
  libxml2-dev expat-dev \
  libgd gd-dev \
  geoip-dev
RUN apk add postgresql-client postgresql-dev

# Install extensions
RUN docker-php-ext-install bcmath xml sockets \
 && docker-php-ext-install pdo pdo_mysql \
 && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
 && docker-php-ext-install pdo_pgsql pgsql

# PHP INI
CMD echo "extension=mongodb.so" >> /usr/local/etc/php/php.ini
CMD echo "extension=amqp.so" >> /usr/local/etc/php/php.ini
CMD echo "extension=redis.so" >> /usr/local/etc/php/php.ini
CMD echo "extension=pdo_pgsql" >> /usr/local/etc/php/php.ini
CMD echo "memory_limit = 512M" >> /usr/local/etc/php/php.ini

RUN apk add php-pear

# PECL
 RUN pecl install mongodb

# Work DIR
WORKDIR /app
COPY . /app

# RUN composer config "platform.ext-mongo" "1.6.16" && composer require alcaeus/mongo-php-adapter
FROM symfony_php as symfony_php_debug

ARG XDEBUG_VERSION=3.0.4
RUN set -eux; \
	pecl install xdebug-$XDEBUG_VERSION; \
	docker-php-ext-enable xdebug;

RUN set -eux; \
    mkdir -p var/cache var/log; \
    composer install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction --ignore-platform-reqs; \
    composer dump-autoload --classmap-authoritative --no-dev; \
    composer symfony:dump-env prod; \
	composer dump-autoload --classmap-authoritative --no-dev; \
	chmod +x bin/console; sync

VOLUME /app/var

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]