#!/bin/sh

# start apache
httpd

# check if mysql data directory is nuked
# if so, install the db
if [ ! -f /var/lib/mysql/ibdata1 ]; then 
    mysql_install_db --user=root > /dev/null
fi;

if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
fi

# default password
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    MYSQL_ROOT_PASSWORD="Admin2015"
    echo "Use default PASSWORD: Admin2015"
fi

tfile=`mktemp`
if [ ! -f "$tfile" ]; then
    return 1
fi

cat << EOF > $tfile
    USE mysql;
    DELETE FROM user;
    FLUSH PRIVILEGES;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "$MYSQL_ROOT_PASSWORD" WITH GRANT OPTION;
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
    UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
    FLUSH PRIVILEGES;
EOF

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile
rm -f $tfile

# start mysql
# nohup mysqld_safe --skip-grant-tables --bind-address 0.0.0.0 --user mysql > /dev/null 2>&1 &
exec /usr/bin/mysqld --user=root --bind-address=0.0.0.0
