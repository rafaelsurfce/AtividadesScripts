#!/bin/bash
apt-get -y install apache2
chmod 777 /var/www/html/index.html



cat << EOF > /usr/local/bin/monitoramento.sh
#!/bin/bash
while true
do
	printf "<h1>""---------------------------------------------------""</h1>" > /usr/local/bin/estado.txt
	printf " \n" >> /usr/local/bin/estado.txt
	printf "<h1>""Estado da maquina:\n""</h1>" >> /usr/local/bin/estado.txt
	printf "<h3>""Horario e Data:\n""</h3>" >> /usr/local/bin/estado.txt
	printf "<h6>" >> /usr/local/bin/estado.txt
	date '+%H:%M:%S %d-%m-%Y' >> /usr/local/bin/estado.txt
	printf "</h6>" >> /usr/local/bin/estado.txt
	printf "<h3>""Tempo em que a maquina esta ativa:\n""</h3>" >> /usr/local/bin/estado.txt
	printf "<h6>" >> /usr/local/bin/estado.txt
	uptime -s >> /usr/local/bin/estado.txt
	printf "</h6>" >> /usr/local/bin/estado.txt
	printf "<h3>""Carga média do sistema: \n""</h3>" >> /usr/local/bin/estado.txt
	printf "<h6>" >> /usr/local/bin/estado.txt
	uptime | grep 'load average.*' >> estado.txt
	printf "</h6>" >> /usr/local/bin/estado.txt
	printf "<h3>""Quantidade de memoria livre e ocupada: \n""</h3>" >> /usr/local/bin/estado.txt
	printf "<h6>" >> /usr/local/bin/estado.txt
	df -h >> /usr/local/bin/estado.txt
	printf "</h6>" >> /usr/local/bin/estado.txt
	printf " \n" >> /usr/local/bin/estado.txt
	printf "<h1>""---------------------------------------------------""</h1>" >> /usr/local/bin/estado.txt

	printf "<html>" > /var/www/html/index.html
	printf "<body>" >> /var/www/html/index.html
	cat /usr/local/bin/estado.txt >> /var/www/html/index.html
	printf "</body>" >> /var/www/html/index.html
	printf "</html>" >> /var/www/html/index.html
	sleep 5
done
EOF

chmod 744 /usr/local/bin/monitoramento.sh


cat << EOF > /etc/systemd/system/monitoramento.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/local/bin/monitoramento.sh

[Install]
WantedBy=default.target
EOF


chmod 664 /etc/systemd/system/monitoramento.service
systemctl daemon-reload
systemctl start monitoramento.service
systemctl enable monitoramento.service


