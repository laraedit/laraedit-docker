#!/usr/bin/env bash

if [[ "$EMAIL" != "app@laraedit.com" && "$DOMAIN" != "app.dev" ]]; then

git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt

cat config.ini >  << EOF
rsa-key-size = 4096
email = $EMAIL
domains = $DOMAIN
authenticator = webroot
webroot-path = /var/www/html/$APP_NAME
EOF

./letsencrypt-auto --config cli.ini

fi
