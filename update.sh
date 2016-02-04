#!/usr/bin/env bash

# update ubuntu
RUN apt-get update
RUN apt-get upgrade -y

# install basic packages
RUN apt-get install -y software-properties-common 
RUN apt-get install -y curl
RUN apt-get install -y build-essential 
RUN apt-get install -y dos2unix 
RUN apt-get install -y gcc 
RUN apt-get install -y git 
RUN apt-get install -y libmcrypt4 
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y make 
RUN apt-get install -y python2.7-dev 
RUN apt-get install -y python-pip 
RUN apt-get install -y re2c 
RUN apt-get install -y unattended-upgrades 
RUN apt-get install -y whois 
RUN apt-get install -y vim 
RUN apt-get install -y libnotify-bin
RUN apt-get install -y nano
RUN apt-get install -y wget

# install ppas
RUN apt-add-repository ppa:nginx/development -y
RUN apt-add-repository ppa:rwky/redis -y
RUN apt-add-repository ppa:ondrej/php-7.0 -y
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
RUN sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
RUN curl -s https://packagecloud.io/gpg.key | apt-key add -
RUN echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list
RUN curl --silent --location https://deb.nodesource.com/setup_5.x | bash -
RUN wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | apt-key add -
RUN echo deb http://dl.hhvm.com/ubuntu trusty main | tee /etc/apt/sources.list.d/hhvm.list

# update package lists
RUN apt-get update
