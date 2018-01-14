From linode/lamp

COPY Genomic-Interactive-Visualization-Engine/give /var/www/give 
COPY import/index.html /var/www/give/html/index.html
COPY import/constants.php /var/www/give/includes/constants.php
COPY import/constants.js /var/www/give/html/components/bower_components/genemo-data-components/basic-func/constants.js
COPY import/001-give.conf /etc/apache2/sites-available/001-give.conf
COPY import/001-give-ssl.conf /etc/apache2/sites-available/001-give-ssl.conf
COPY import/setgive_script.sh /tmp/setgive_script.sh
COPY import/dump_compbrowser.sql /tmp/dump_compbrowser.sql
COPY import/dump_hg19.sql /tmp/dump_hg19.sql
COPY import/start.sh /bin/start.sh

## use script to set apache2, mysql database with built-in tracks
RUN /bin/bash /tmp/setgive_script.sh

EXPOSE 80 443 3306 

CMD start.sh && /bin/bash
