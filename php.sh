#!/usr/bin/env bash

# install php
apt-get install -y --force-yes php7.0-cli
apt-get install -y --force-yes php7.0-fpm
apt-get install -y --force-yes php7.0-dev
apt-get install -y --force-yes php-pgsql
apt-get install -y --force-yes php-sqlite3
apt-get install -y --force-yes php-gd
apt-get install -y --force-yes php-apcu
apt-get install -y --force-yes php-curl
apt-get install -y --force-yes php-imap
apt-get install -y --force-yes php-mysql
apt-get install -y --force-yes php-memcached
apt-get install -y --force-yes php7.0-readline
apt-get install -y --force-yes php-xdebug

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini
# sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
# sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini

# cat > /etc/nginx/fastcgi_params << EOF
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
