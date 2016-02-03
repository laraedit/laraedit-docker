FROM ubuntu:14.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

# update ubuntu
RUN apt-get update
RUN apt-get upgrade -y

# install openssh
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
EXPOSE 22

# install supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
VOLUME ["/var/log/supervisor"]
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install nginx
VOLUME ["/var/cache/nginx"]
VOLUME ["/var/log/nginx"]
EXPOSE 80 443

# clean up
RUN rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/supervisord"]
