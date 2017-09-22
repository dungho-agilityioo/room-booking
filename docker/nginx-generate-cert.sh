#!/bin/bash

DOMAIN=$1
EMAIL=$2

if [[ ( "$DOMAIN" = ""  ) || ( "$EMAIL" = "" )]]; then
    echo 1>&2 "$0: Missing domain or email in arguments"
else
    docker-compose \
        run --rm proxy \
        certbot certonly --webroot --webroot-path /var/www/letsencrypt \
            --pre-hook "rm -rf /etc/letsencrypt/live/$DOMAIN" \
            --post-hook "nginx -s reload" \
            --config /etc/letsencrypt/configs/$DOMAIN.conf \
            --email $EMAIL \
            -d $DOMAIN
fi
