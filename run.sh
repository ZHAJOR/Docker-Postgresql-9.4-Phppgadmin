#!/bin/bash

rm /run/apache2/apache2.pid
service postgresql start
exec /usr/sbin/apache2ctl -D FOREGROUND
