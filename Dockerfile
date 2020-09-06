FROM ubuntu:18.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

# set some environment variables
ENV APP_NAME app
ENV APP_EMAIL app@laraedit.com
ENV APP_DOMAIN app.dev
ENV DEBIAN_FRONTEND noninteractive

# upgrade the container
RUN apt-get update && \
    apt-get upgrade -y

# install some prerequisites
RUN apt-get install --assume-yes software-properties-common curl build-essential \
    dos2unix gcc git libmcrypt4 libpcre3-dev memcached make python2.7-dev \
    python-pip re2c unattended-upgrades whois vim libnotify-bin nano wget \
    debconf-utils locales libpng-dev rsync unzip imagemagick zip

# add some repositories
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash - && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update

# set the locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale  && \
    locale-gen en_US.UTF-8  && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    
# setup bash
COPY .bash_aliases /root

# install nginx
RUN apt-get install --assume-yes --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx
COPY homestead /etc/nginx/sites-available/
RUN rm -rf /etc/nginx/sites-available/default && \
    rm -rf /etc/nginx/sites-enabled/default && \
    ln -fs "/etc/nginx/sites-available/homestead" "/etc/nginx/sites-enabled/homestead" && \
    sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf && \
    sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    usermod -u 1000 www-data && \
    chown -Rf www-data.www-data /var/www/html/ && \
    sed -i -e"s/worker_processes  1/worker_processes 5/" /etc/nginx/nginx.conf
VOLUME ["/var/www/html/app"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]

# install php
RUN apt-get install --assume-yes --allow-downgrades --allow-remove-essential --allow-change-held-packages php-fpm php-cli php-dev php-pgsql php-sqlite3 php-gd \
    php-apcu php-curl php-imap php-mysql php-readline php-xdebug php-common \
    php-mbstring php-xml php-zip php-bcmath php-soap php-imagick
COPY fastcgi_params /etc/nginx/
RUN mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php

# install node and databases 
RUN apt-get install --assume-yes --allow-downgrades --allow-remove-essential --allow-change-held-packages nodejs sqlite3 libsqlite3-dev redis-server postgresql postgresql-contrib

# install mysql 
RUN echo mysql-server mysql-server/root_password password $DB_PASS | debconf-set-selections;\
    echo mysql-server mysql-server/root_password_again password $DB_PASS | debconf-set-selections;\
    apt-get install --assume-yes mysql-server && \
    echo "[mysqld]" >> /etc/mysql/my.cnf && \
    echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf && \
    sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
RUN find /var/lib/mysql -exec touch {} \; && service mysql start && \
    sleep 10s && \
    echo "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret'; GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION; FLUSH PRIVILEGES; CREATE DATABASE homestead;" | mysql
VOLUME ["/var/lib/mysql"]

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc
    
# install laravel envoy
RUN composer global require "laravel/envoy" "laravel/installer"

# install beanstalkd
# RUN apt-get install --assume-yes --allow-downgrades --allow-remove-essential --allow-change-held-packages beanstalkd && \
#     sed -i "s/BEANSTALKD_LISTEN_ADDR.*/BEANSTALKD_LISTEN_ADDR=0.0.0.0/" /etc/default/beanstalkd && \
#     sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd && \
#     /etc/init.d/beanstalkd start

# install supervisor
RUN apt-get install --assume-yes supervisor && \
    mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/var/log/supervisor"]

# clean up our mess
RUN apt-get remove --purge --assume-yes software-properties-common && \
    apt-get autoremove --assume-yes && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

# expose ports
EXPOSE 80 443 3306 6379

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]
