FROM ubuntu:14.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

ENV APP_NAME app
ENV APP_EMAIL app@laraedit.com
ENV APP_DOMAIN app.dev

RUN export DEBIAN_FRONTEND=noninteractive

# update ubuntu
COPY update.sh /provision/update.sh
RUN sh /provision/update.sh

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
COPY composer.sh /provision/composer.sh
RUN sh /provision/composer.sh
VOLUME ["~/.composer"]

# install hhvm
# COPY hhvm.sh /provision/hhvm.sh
# RUN sh /provision/hhvm.sh

# install mysql
# COPY mysql.sh /provision/mysql.sh
# RUN sh /provision/mysql.sh
# EXPOSE 3006

# install sqlite
# COPY sqlite.sh /provision/sqlite.sh
# RUN sh /provision/sqlite.sh

# install beanstalkd
# COPY beanstalkd.sh /provision/beanstalkd.sh
# RUN sh /provision/beanstalkd.sh

# install postgresql
# COPY postgresql.sh /provision/postgresql.sh
# RUN sh /provision/postgresql.sh

# install redis
# COPY redis.sh /provision/redis.sh
# RUN sh /provision/redis.sh
# EXPOSE 6379

# install nodejs
# COPY nodejs.sh /provision/nodejs.sh
# RUN sh /provision/nodejs.sh

# install blackfire
# COPY blackfire.sh /provision/blackfire.sh
# RUN sh /provision/blackfire.sh

# install letsencrypt
# COPY letsencrypt.sh /provision/letsencrypt.sh
# RUN sh /provision/letsencrypt.sh

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
RUN dd if=/dev/zero of=/EMPTY bs=1M
RUN rm -f /EMPTY
RUN sync

CMD ["/usr/bin/supervisord"]
