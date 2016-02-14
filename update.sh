#!/usr/bin/env bash

# update ubuntu
apt-get update
apt-get upgrade -y

# install basic packages
apt-get install -y software-properties-common
apt-get install -y curl
apt-get install -y build-essential
apt-get install -y dos2unix
apt-get install -y gcc
apt-get install -y git
apt-get install -y libmcrypt4
apt-get install -y libpcre3-dev
apt-get install -y make
apt-get install -y python2.7-dev
apt-get install -y python-pip
apt-get install -y re2c
apt-get install -y unattended-upgrades
apt-get install -y whois
apt-get install -y vim
apt-get install -y libnotify-bin
apt-get install -y nano
apt-get install -y wget

# install ppas
apt-add-repository ppa:nginx/development -y
apt-add-repository ppa:rwky/redis -y
apt-add-repository ppa:ondrej/php-7.0 -y

apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

curl -s https://packagecloud.io/gpg.key | apt-key add -
echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

curl --silent --location https://deb.nodesource.com/setup_5.x | bash -

wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list

# update package lists
apt-get update

# force locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

# set timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
