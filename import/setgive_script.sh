#!/bin/bash
# install php-mysqlnd
apt-get update
apt-get install -y php5-mysqlnd
rm -rf /var/lib/apt/lists/*
# delete original example.com files
a2dissite example.com
rm -rf /var/www/example.com
# enable SSL 443 port for https access
a2enmod ssl include headers cgi
a2ensite 001-give 001-give-ssl

# import GIVE database to MySQL, root passwd: Admin2015
/usr/bin/mysqld_safe --skip-grant-tables &
sleep 5
mysql -u root -e "CREATE DATABASE compbrowser"
mysql -u root -e "CREATE DATABASE hg19"
mysql -u root compbrowser < /tmp/setting/dump_compbrowser.sql
mysql -u root hg19 < /tmp/setting/dump_hg19.sql

rm -r /tmp/setting
chmod +x /usr/local/bin/*.sh
chmod +x /bin/start.sh
