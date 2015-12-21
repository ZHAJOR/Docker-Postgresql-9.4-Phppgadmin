FROM debian:jessie

MAINTAINER Pierre-Antoine 'ZHAJOR' Tible <antoinetible@gmail.com>

RUN apt-get update
RUN apt-get -y install apache2 libapache2-mod-php5 php5 php5-pgsql postgresql-9.4 postgresql-client-9.4 postgresql-contrib wget unzip
RUN apt-get clean

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

RUN ln -sf /dev/stdout /var/log/apache2/access.log 
RUN ln -sf /dev/stdout /var/log/apache2/error.log

RUN chown -R www-data:www-data /var/log/apache2 /var/www/html

WORKDIR /var/www/html
RUN wget https://github.com/phppgadmin/phppgadmin/archive/master.zip
RUN rm /var/www/html/index.html && unzip /var/www/html/master.zip
RUN cp -R phppgadmin-master/* . && rm -r phppgadmin-master
RUN cp conf/config.inc.php-dist conf/config.inc.php
RUN sed -i "s/\$conf\['extra_login_security'\] = true;/\$conf\['extra_login_security'\] = false;/g" conf/config.inc.php
RUN sed -i "s/\$conf\['servers'\]\[0\]\['host'\] = '';/\$conf\['servers'\]\[0\]\['host'\] = 'localhost';/g" conf/config.inc.php
RUN service postgresql start; \
  su - postgres -c "/usr/lib/postgresql/9.4/bin/psql -U postgres -c \"ALTER USER postgres with password 'postgres';\""

RUN service apache2 stop

EXPOSE 5432
EXPOSE 80

CMD service postgresql start; \
    /usr/sbin/apache2ctl -D FOREGROUND
