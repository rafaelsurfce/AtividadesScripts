#!/bin/bash
apt-get -y install apache2
chmod 777 /var/www/html/index.html



cat << EOF > /usr/local/bin/monitoramento.sh
#!/bin/bash

printf "<h1>""---------------------------------------------------""</h1>" > /usr/local/bin/estado.txt
printf " \n" >> /usr/local/bin/estado.txt
printf "<h1>""Estado da maquina:\n""</h1>" >> /usr/local/bin/estado.txt
printf "<h3>""Horario e Data:\n""</h3>" >> /usr/local/bin/estado.txt
printf "<h6>" >> /usr/local/bin/estado.txt
date '+%H:%M:%S %d-%m-%Y' >> /usr/local/bin/estado.txt
printf "</h6>" >> /usr/local/bin/estado.txt
printf "<h3>""Tempo em que a maquina esta ativa:\n""</h3>" >> /usr/local/bin/estado.txt
printf "<h6>" >> /usr/local/bin/estado.txt
uptime -p >> /usr/local/bin/estado.txt
printf "</h6>" >> /usr/local/bin/estado.txt
printf "<h3>""Carga média do sistema: \n""</h3>" >> /usr/local/bin/estado.txt
printf "<h6>" >> /usr/local/bin/estado.txt
uptime | awk '{ printf \$7 " " \$8 " " \$9 " " \$10 " " \$11 "\n"}' >> /usr/local/bin/estado.txt
printf "</h6>" >> /usr/local/bin/estado.txt
printf "<h3>""Quantidade de memoria livre e ocupada: \n""</h3>" >> /usr/local/bin/estado.txt
printf "<h6>" >> /usr/local/bin/estado.txt
free | grep Mem | awk '{ printf "Ocupado: %d, Disponivel: %d\n", \$3, \$4 }' >> /usr/local/bin/estado.txt
printf "</h6>" >> /usr/local/bin/estado.txt
printf "<h3>""Quantidades de Bytes e enviados atráves  da interface eth0""</h3>" >> /usr/local/bin/estado.txt
printf "<h6>""\n" >> /usr/local/bin/estado.txt
grep  'eth0' /proc/net/dev | awk '{ printf "Recebidos: %d, Transmitidos: %d\n", \$2, \$10 }' >> /usr/local/bin/estado.txt
printf "</h6>""\n" >> /usr/local/bin/estado.txt
printf " \n" >> /usr/local/bin/estado.txt
printf "<h1>""---------------------------------------------------""</h1>" >> /usr/local/bin/estado.txt

printf "<html>" > /var/www/html/index.html
printf "<head>" >> /var/www/html/index.html
printf '<meta charset="utf-8">' >> /var/www/html/index.html
printf "<title>""Estado da Maquina""</title>" >> /var/www/html/index.html
printf "</head>" >> /var/www/html/index.html
printf "<body>" >> /var/www/html/index.html
cat /usr/local/bin/estado.txt >> /var/www/html/index.html
printf "</body>" >> /var/www/html/index.html
printf "</html>" >> /var/www/html/index.html
EOF

chmod 744 /usr/local/bin/monitoramento.sh


echo "*/1 * * * * root /usr/local/bin/monitoramento.sh" >> /etc/crontab




