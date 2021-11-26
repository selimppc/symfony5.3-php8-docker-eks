#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

# composer update
# composer update --prefer-dist --no-progress --no-interaction --ignore-platform-reqs

setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var

# starting nginx
/usr/sbin/nginx

exec docker-php-entrypoint "$@"
