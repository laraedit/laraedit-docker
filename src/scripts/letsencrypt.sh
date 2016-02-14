#!/usr/bin/env bash

if [[ $APP_EMAIL != "app@laraedit.com" && $APP_DOMAIN != "app.dev" ]]; then

git clone https://github.com/letsencrypt/letsencrypt
cd letsencrypt

cat config.ini >  << EOF
rsa-key-size = 4096
email = $APP_EMAIL
domains = $APP_DOMAIN
authenticator = webroot
webroot-path = /var/www/html/$APP_NAME
EOF

./letsencrypt-auto --config cli.ini

fi
