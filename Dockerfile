FROM alpine:3.7
ENV TIMEZONE America/Los_Angeles

########## set up and configure LAMP
RUN apk update && apk upgrade && \
    apk add mariadb mariadb-client \
    apache2 \ 
    apache2-utils \
    curl wget vim htop \
    tzdata \
    php7-apache2 \
    php7-cli \
    php7-phar \
    php7-zlib \
    php7-zip \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-pdo_mysql \
    php7-mysqli \
    php7-json \
    php7-mcrypt \
    php7-xml \
    php7-dom \
    php7-iconv \
    php7-xdebug \
    php7-session \
    coreutils \
    bash && \
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin --filename=composer && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    mysql_install_db --user=mysql --verbose=1 --basedir=/usr --datadir=/var/lib/mysql --rpm > /dev/null && \
    mkdir -p /run/apache2 && chown -R apache:apache /run/apache2 && \
    mkdir -p /var/www/give/html && chown -R apache:apache /var/www/give/html/ && \
    sed -i 's#\#LoadModule rewrite_module modules\/mod_rewrite.so#LoadModule rewrite_module modules\/mod_rewrite.so#' /etc/apache2/httpd.conf && \
    sed -i 's#ServerName www.example.com:80#\nServerName localhost:80#' /etc/apache2/httpd.conf && \
    sed -i 's#^DocumentRoot ".*"#DocumentRoot "/var/www/give/html"#g' /etc/apache2/httpd.conf && \
    sed -i 's#^<Directory ".*">#<Directory "/var/www/give/html">\n\tHeader set Access-Control-Allow-Origin "*"\n\tHeader append Access-Control-Allow-Headers "content-type"\n#g' /etc/apache2/httpd.conf && \
    sed -i '/skip-external-locking/a log_error = \/var\/lib\/mysql\/error.log' /etc/mysql/my.cnf && \
    sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf && \
    sed -i '/skip-external-locking/a general_log = ON' /etc/mysql/my.cnf && \
    sed -i '/skip-external-locking/a general_log_file = \/var\/lib\/mysql\/query.log' /etc/mysql/my.cnf

COPY import/my.cnf /etc/mysql/my.cnf

# GIVE php code may have some warnings, keep xdebug and error report disabled 
# RUN sed -i 's#display_errors = Off#display_errors = On#' /etc/php7/php.ini && \
#    sed -i 's#error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT#error_reporting = E_ALL#' /etc/php7/php.ini
# Configure xdebug
#RUN echo "zend_extension=xdebug.so" > /etc/php7/conf.d/xdebug.ini && \ 
#    echo -e "\n[XDEBUG]"  >> /etc/php7/conf.d/xdebug.ini && \ 
#    echo "xdebug.remote_enable=1" >> /etc/php7/conf.d/xdebug.ini && \  
#    echo "xdebug.remote_connect_back=1" >> /etc/php7/conf.d/xdebug.ini && \ 
#    echo "xdebug.idekey=PHPSTORM" >> /etc/php7/conf.d/xdebug.ini && \ 
#    echo "xdebug.remote_log=\"/tmp/xdebug.log\"" >> /etc/php7/conf.d/xdebug.ini

########### set up and configure GIVE

COPY Genomic-Interactive-Visualization-Engine/html /tmp/html 
COPY Genomic-Interactive-Visualization-Engine/includes /tmp/includes 
COPY Genomic-Interactive-Visualization-Engine/GIVE-Toolbox/*.sh /usr/local/bin/ 
COPY import/constants.php /var/www/give/includes/constants.php
COPY import/constants.js /var/www/give/html/components/basic-func/constants.js
COPY import/entry.sh /entry.sh

RUN cp -r /tmp/html/* /var/www/give/html && \
    cp -r /tmp/includes/* /var/www/give/includes && \
    chmod +x /usr/local/bin/*.sh && \
    chmod u+x /entry.sh && \
    rm -r /tmp/html /tmp/includes 

WORKDIR /tmp

EXPOSE 80 443 3306

ENTRYPOINT ["/entry.sh"]
