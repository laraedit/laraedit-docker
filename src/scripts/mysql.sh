#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# install mysql
debconf-set-selections <<< "mysql-community-server mysql-community-server/data-dir select ''"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password secret"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password secret"
apt-get install -y mysql-server

echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

# mysql --user="root" --password="secret" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
# mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
# mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
# mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
# mysql --user="root" --password="secret" -e "CREATE DATABASE homestead;"
# service mysql restart

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql
