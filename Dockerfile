FROM ubuntu:16.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

# set some environment variables
ENV APP_NAME app
ENV APP_EMAIL app@laraedit.com
ENV APP_DOMAIN app.dev
ENV DEBIAN_FRONTEND noninteractive

# upgrade the container
RUN apt-get update && \
    apt-get upgrade -y
    
# set the locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale  && \
    locale-gen en_US.UTF-8  && \
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# install some prerequisites
RUN apt-get install -y software-properties-common curl build-essential \
    dos2unix gcc git libmcrypt4 libpcre3-dev memcached make python2.7-dev \
    python-pip re2c unattended-upgrades whois vim libnotify-bin nano wget \
    debconf-utils

# add some repositories
RUN apt-add-repository ppa:nginx/development -y && \
    apt-add-repository ppa:chris-lea/redis-server -y && \
    apt-add-repository ppa:ondrej/php -y && \
    curl -s https://packagecloud.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list && \
    curl --silent --location https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update
    
# set the timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# setup bash
COPY .bash_aliases /root

# install nginx
RUN apt-get install -y --force-yes nginx
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
COPY fastcgi_params /etc/nginx/
VOLUME ["/var/www/html/app"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]

# install php
RUN apt-get install -y --force-yes php7.0-cli php7.0-dev php-pgsql \
    php-sqlite3 php-gd php-apcu php-curl php7.0-mcrypt php-imap \
    php-mysql php-memcached php7.0-readline php-xdebug php-mbstring \
    php-xml php7.0-zip php7.0-intl php7.0-bcmath php-soap 
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini && \ 
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini && \
    echo "xdebug.remote_enable = 1" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini && \
    echo "xdebug.remote_connect_back = 1" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini && \
    echo "xdebug.remote_port = 9000" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini && \
    echo "xdebug.max_nesting_level = 512" >> /etc/php/7.0/fpm/conf.d/20-xdebug.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
RUN phpdismod -s cli xdebug
RUN phpenmod mcrypt && \
    mkdir -p /run/php/ && chown -Rf www-data.www-data /run/php
    
# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc 
    
# install laravel envoy
RUN composer global require "laravel/envoy"

# install laravel installer
RUN composer global require "laravel/installer"

# install lumen installer
RUN composer global require "laravel/lumen-installer"

# install nodejs
RUN apt-get install -y nodejs && \
    /usr/bin/npm install -g gulp && \
    /usr/bin/npm install -g bower

# install sqlite 
RUN apt-get install -y sqlite3 libsqlite3-dev

# install mysql 
RUN echo mysql-server mysql-server/root_password password $DB_PASS | debconf-set-selections;\
    echo mysql-server mysql-server/root_password_again password $DB_PASS | debconf-set-selections;\
    apt-get install -y mysql-server && \
    echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf && \
    sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf
RUN /usr/sbin/mysqld && \
    sleep 10s && \
    echo "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret'; GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION; GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION; FLUSH PRIVILEGES; CREATE DATABASE homestead;" | mysql
VOLUME ["/var/lib/mysql"]

# install postgres
RUN apt-get install -y postgresql

# install redis 
RUN apt-get install -y redis-server

# install blackfire
RUN apt-get install -y blackfire-agent blackfire-php

# install beanstalkd
RUN apt-get install -y --force-yes beanstalkd && \
    sed -i "s/BEANSTALKD_LISTEN_ADDR.*/BEANSTALKD_LISTEN_ADDR=0.0.0.0/" /etc/default/beanstalkd && \
    sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd && \
    /etc/init.d/beanstalkd start

# restart services
RUN service nginx restart && \
    service php7.0-fpm restart && \
    service mysql restart && \
    service postgresql restart

# install supervisor
RUN apt-get install -y supervisor && \
    mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
VOLUME ["/var/log/supervisor"]

# clean up our mess
RUN apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
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
