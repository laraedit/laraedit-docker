FROM ubuntu:14.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

ENV APP_NAME app
ENV APP_EMAIL app@laraedit.com
ENV APP_DOMAIN app.dev
ENV DEBIAN_FRONTEND noninteractive

# import provisioning files
COPY src/ /provision/

# update ubuntu
RUN sh /provision/scripts/update.sh

# install nginx
RUN sh /provision/scripts/nginx.sh
VOLUME ["/var/www/html/$APP_NAME"]
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]
EXPOSE 80 443

# install php
RUN sh /provision/scripts/php.sh
RUN service nginx restart
EXPOSE 9000

# install composer
RUN sh /provision/scripts/composer.sh

# install hhvm
RUN sh /provision/scripts/hhvm.sh

# install mysql
# RUN sh /provision/scripts/mysql.sh
# EXPOSE 3306

# install sqlite
RUN sh /provision/scripts/sqlite.sh

# install beanstalkd
RUN sh /provision/scripts/beanstalkd.sh

# install postgresql
# RUN sh /provision/scripts/postgresql.sh

# install redis
RUN sh /provision/scripts/redis.sh
EXPOSE 6379

# install nodejs
RUN sh /provision/scripts/nodejs.sh

# install blackfire
RUN sh /provision/scripts/blackfire.sh

# install letsencrypt
# RUN sh /provision/scripts/letsencrypt.sh

# install openssh
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
EXPOSE 22

# install supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
VOLUME ["/var/log/supervisor"]
RUN ln -s /provision/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# clean up
RUN apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_*

ENTRYPOINT ["/bin/bash","-c"]
CMD ["/usr/bin/supervisord"]
