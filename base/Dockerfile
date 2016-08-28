FROM ubuntu:16.04
MAINTAINER Derek Bourgeois <derek@ibourgeois.com>

# upgrade the container
RUN apt-get update && \
    apt-get upgrade -y

# install some prerequisites
RUN apt-get install -y software-properties-common curl build-essential \
    dos2unix gcc git libmcrypt4 libpcre3-dev memcached make python2.7-dev \
    python-pip re2c unattended-upgrades whois vim libnotify-bin nano wget \
    debconf-utils apt-utils language-pack-en-base

# set the locale
RUN export LC_ALL=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# set the timezone
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# setup bash
COPY .bash_aliases /root

# set container entrypoints
ENTRYPOINT ["/bin/bash","-c"]