#!/usr/bin/env bash

# install beanstalkd
apt-get install -y beanstalkd
sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
# /etc/init.d/beanstalkd start
