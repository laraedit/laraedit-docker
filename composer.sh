#!/usr/bin/env bash

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
# printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.profile

# install laravel
composer global require "laravel/envoy"
composer global require "laravel/installer"
# composer global require "laravel/lumen-installer"
