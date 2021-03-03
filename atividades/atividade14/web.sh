#!/bin/bash

apt-get -y install apache2
chmod 777 /var/www/html/index.html
echo "<html>" > /var/www/html/index.html
echo "<body>" >> /var/www/html/index.html
echo "<h1> Nome: Rafael Lima Matricula: 428453 </h1>"  >> /var/www/html/index.html
echo "</body>" >> /var/www/html/index.html
echo "</html>" >> /var/www/html/index.html

