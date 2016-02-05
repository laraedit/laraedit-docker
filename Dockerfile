FROM ubuntu:14.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

ENV APP_NAME app

RUN export DEBIAN_FRONTEND=noninteractive

# update ubuntu
COPY update.sh /provision/update.sh
RUN sh /provision/update.sh

# force locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
RUN locale-gen en_US.UTF-8

# set timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# install nginx
COPY nginx.sh /provision/nginx.sh
RUN sh /provision/nginx.sh
VOLUME ["/var/www/html/$APP_NAME"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]
EXPOSE 80 443

# install php
COPY php.sh /provision/php.sh
RUN sh /provision/php.sh
RUN service nginx restart
EXPOSE 9000

# install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
# RUN printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.profile

# install laravel
RUN composer global require "laravel/envoy"
RUN composer global require "laravel/installer"
# RUN composer global require "laravel/lumen-installer"

# install hhvm
# RUN apt-get install -y hhvm
# RUN service hhvm stop
# RUN sed -i 's/#RUN_AS_USER="www-data"/RUN_AS_USER="vagrant"/' /etc/default/hhvm
# RUN service hhvm start
# RUN update-rc.d hhvm defaults

# install mysql

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
