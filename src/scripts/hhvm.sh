#!/usr/bin/env bash

# install hhvm
apt-get install -y hhvm
# service hhvm stop
# sed -i 's/#RUN_AS_USER="www-data"/RUN_AS_USER="vagrant"/' /etc/default/hhvm
# service hhvm start
# update-rc.d hhvm defaults
