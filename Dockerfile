FROM ubuntu:14.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

ENV APP_NAME app

RUN export DEBIAN_FRONTEND=noninteractive

# update ubuntu
RUN apt-get update
RUN apt-get upgrade -y

# force locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
RUN locale-gen en_US.UTF-8

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

# set timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# install php
RUN apt-get install -y --force-yes php7.0-cli
RUN apt-get install -y --force-yes php7.0-dev
RUN apt-get install -y --force-yes php-pgsql
RUN apt-get install -y --force-yes php-sqlite3
RUN apt-get install -y --force-yes php-gd
RUN apt-get install -y --force-yes php-apcu
RUN apt-get install -y --force-yes php-curl
RUN apt-get install -y --force-yes php-imap
RUN apt-get install -y --force-yes php-mysql
RUN apt-get install -y --force-yes php-memcached
RUN apt-get install -y --force-yes php7.0-readline
RUN apt-get install -y --force-yes php-xdebug
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini
RUN sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini
RUN sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
# RUN printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.profile

# install laravel
RUN composer global require "laravel/envoy"
RUN composer global require "laravel/installer"
RUN composer global require "laravel/lumen-installer"

# install nginx and php-fpm
RUN apt-get install -y --force-yes nginx 
RUN apt-get install -y --force-yes php7.0-fpm
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default
RUN service nginx restart
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini

# RUN cat > /etc/nginx/fastcgi_params << EOF
# fastcgi_param	QUERY_STRING		\$query_string;
# fastcgi_param	REQUEST_METHOD		\$request_method;
# fastcgi_param	CONTENT_TYPE		\$content_type;
# fastcgi_param	CONTENT_LENGTH		\$content_length;
# fastcgi_param	SCRIPT_FILENAME		\$request_filename;
# fastcgi_param	SCRIPT_NAME		\$fastcgi_script_name;
# fastcgi_param	REQUEST_URI		\$request_uri;
# fastcgi_param	DOCUMENT_URI		\$document_uri;
# fastcgi_param	DOCUMENT_ROOT		\$document_root;
# fastcgi_param	SERVER_PROTOCOL		\$server_protocol;
# fastcgi_param	GATEWAY_INTERFACE	CGI/1.1;
# fastcgi_param	SERVER_SOFTWARE		nginx/\$nginx_version;
# fastcgi_param	REMOTE_ADDR		\$remote_addr;
# fastcgi_param	REMOTE_PORT		\$remote_port;
# fastcgi_param	SERVER_ADDR		\$server_addr;
# fastcgi_param	SERVER_PORT		\$server_port;
# fastcgi_param	SERVER_NAME		\$server_name;
# fastcgi_param	HTTPS			\$https if_not_empty;
# fastcgi_param	REDIRECT_STATUS		200;
# EOF

# install hhvm
# RUN apt-get install -y hhvm
# RUN service hhvm stop
# RUN sed -i 's/#RUN_AS_USER="www-data"/RUN_AS_USER="vagrant"/' /etc/default/hhvm
# RUN service hhvm start
# RUN update-rc.d hhvm defaults

VOLUME ["/usr/share/nginx/html/$APP_NAME"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]
EXPOSE 80 443 9000

# install openssh
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
EXPOSE 22

# install supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
VOLUME ["/var/log/supervisor"]
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# clean up
RUN rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/supervisord"]
