From linode/lamp

COPY Genomic-Interactive-Visualization-Engine/html /var/www/give/html 
COPY Genomic-Interactive-Visualization-Engine/includes /var/www/give/includes 
COPY Genomic-Interactive-Visualization-Engine/GIVE-Toolbox/*.sh /usr/local/bin/ 
COPY Genomic-Interactive-Visualization-Engine/GIVE-Toolbox/example_data /tmp/example_data 

COPY import/index.html /var/www/give/html/index.html
COPY import/constants.php /var/www/give/includes/constants.php
COPY import/constants.js /var/www/give/html/components/basic-func/constants.js
COPY import/001-give.conf /etc/apache2/sites-available/001-give.conf
COPY import/001-give-ssl.conf /etc/apache2/sites-available/001-give-ssl.conf
COPY import/setgive_script.sh /tmp/setting/setgive_script.sh
COPY import/dump_compbrowser.sql /tmp/setting/dump_compbrowser.sql
COPY import/dump_hg19.sql /tmp/setting/dump_hg19.sql
COPY import/start.sh /bin/start.sh

## use script to set apache2, mysql database with built-in tracks
RUN /bin/bash /tmp/setting/setgive_script.sh

EXPOSE 80 443 3306 

CMD start.sh && /bin/bash
