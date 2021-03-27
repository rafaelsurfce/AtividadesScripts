#!/bin/bash

#Declaração de variaveis e parametros
ipPublico=$(wget -qO- https://ipecho.net/plain)
imagem=ami-03d315ad33b9d49c4 
subnetId=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
chave=$1
usuario=$2
senha=$3
db=scripts
ip1=
ip2=

#Criaçaõ do Grupo de Segurança
grupoSecurity=$(aws ec2 create-security-group --group-name "atividade18" --description "Atividade18"  --output text)

#Configuração de portas
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 22 --cidr $ipPublico/32
aws ec2 authorize-security-group-ingress --group-name "atividade18" --protocol tcp --port 3306 --source-group $grupoSecurity

#Criando scripts da maquina1
cat<<EOF > serv.sh
#!/bin/bash 
apt update
apt-get -y install mysql-server

sed -i '32c\mysqlx-bind-address   = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '31c\bind-address          = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql.service

mysql<<FIM
CREATE DATABASE $db;
CREATE USER '$usuario'@'%' IDENTIFIED BY '$senha';
GRANT ALL PRIVILEGES ON scripts.* TO '$usuario'@'%';
FIM

EOF
chmod +x serv.sh

#Criando maquina de Banco de Dados
echo "Criando servidor de Bancos de Dados..."
idInstancia1=$(aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --security-group-ids $grupoSecurity --subnet $subnetId --key-name $chave --user-data file://serv.sh --query "Instances[0].InstanceId" --output text)
while [ true ]
do
	sleep 5
	describe=$(aws ec2 describe-instances --instance-id $idInstancia1 --query "Reservations[0].Instances[].State.Name" --output text)

	if [ $describe = "running" ]
	then
		ip1=$(aws ec2 describe-instances --instance-id $idInstancia1 --query "Reservations[0].Instances[].PrivateIpAddress" --output text)
		echo "IP Privado do Banco de Dados: "$ip1
		break
	else
		continue
	fi	
done


#Configuração do script cliente
cat<<EOF > client.sh
#!/bin/bash

#Instalação e configuração do Banco de Dados cliente
apt update
apt-get -y install mysql-client

echo "[client]" > /root/.my.cnf
echo "user="$usuario >> /root/.my.cnf
echo "password="$senha >> /root/.my.cnf

#Instalação e configuração wordpress
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip


cat<<FIM > /etc/apache2/sites-available.wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
FIM

a2enmod rewrite
a2ensite wordpress
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch wordpress/.htaccess
cp -a wordpress/. /var/www/html/wordpress
systemctl restart apache2.service
 
echo "<?php" > /tmp/wp-config.php 
echo "define( 'DB_NAME', '$db' );" >> /tmp/wp-config.php
echo "define( 'DB_USER', '$usuario' );" >> /tmp/wp-config.php
echo "define( 'DB_PASSWORD', '$senha' );" >> /tmp/wp-config.php
echo "define( 'DB_HOST', '$ip1' );" >> /tmp/wp-config.php
echo "define( 'DB_CHARSET', 'utf8' );" >> /tmp/wp-config.php
echo "define( 'DB_COLLATE', '' );" >> /tmp/wp-config.php
echo "" >> /tmp/wp-config.php


curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /tmp/wp-config.php

echo "" >> /tmp/wp-config.php

echo "\\\$table_prefix = 'wp_';" >> /tmp/wp-config.php
echo "" >> /tmp/wp-config.php

echo "define( 'WP_DEBUG', false );" >> /tmp/wp-config.php
echo "" >> /tmp/wp-config.php

echo "if ( ! defined( 'ABSPATH' ) ) {" >> /tmp/wp-config.php
echo "        define( 'ABSPATH', __DIR__ . '/' );" >>/tmp/wp-config.php
echo "}" >> /tmp/wp-config.php
echo "" >> /tmp/wp-config.php
echo "require_once ABSPATH . 'wp-settings.php';" >> /tmp/wp-config.php

cp /tmp/wp-config.php /var/www/html/wordpress/

chown -R www-data:www-data /var/www/html/wordpress
find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;
find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;

systemctl restart apache2.service

EOF
chmod +x client.sh

sleep 10

#Criando maquina de cliente
echo "Criando servidor de Aplicação..."
idInstancia2=$(aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --security-group-ids $grupoSecurity --subnet $subnetId --key-name $chave --user-data file://client.sh --query "Instances[0].InstanceId" --output text)
while [ true ]
do
	sleep 3
	describe=$(aws ec2 describe-instances --instance-id $idInstancia2 --query "Reservations[0].Instances[].State.Name" --output text)
	if [ $describe = "running" ]
	then
		ip2=$(aws ec2 describe-instances --instance-id $idInstancia2 --query "Reservations[0].Instances[].PublicIpAddress" --output text)
		sleep 15
                echo "IP Publico do Servidor de APlicação: "$ip2
		echo " "
		echo "Acesse http://$ip2/wordpress para finalizar a configuração."
                break
	else
		continue
	fi
done
rm serv.sh client.sh




