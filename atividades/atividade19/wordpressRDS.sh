#!/bin/bash

#Declaração de variaveis e parametros
ipPublico=$(wget -qO- https://ipecho.net/plain)
imagem=ami-03d315ad33b9d49c4 
subnetId=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
chave=$1
usuario=$2
senha=$3
db=wordpress
ip1=
ip2=

#Criaçaõ do Grupo de Segurança
grupoSecurity=$(aws ec2 create-security-group --group-name "atividade19" --description "Atividade19"  --output text)

#Configuração de portas
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 22 --cidr $ipPublico/32
aws ec2 authorize-security-group-ingress --group-name "atividade19" --protocol tcp --port 3306 --source-group $grupoSecurity

#Criando Banco de Dados no rds
echo "Criando Instancia de Bancos de Dados no RDS..."
aws rds create-db-instance --db-instance-identifier scripts --vpc-security-group-ids $grupoSecurity --engine mysql --master-username $usuario --master-user-password $senha --allocated-storage 20 --no-publicly-accessible --db-instance-class db.t2.micro > /dev/null
while [ true ]
do
	sleep 5
	describe=$(aws rds describe-db-instances --db-instance-identifier scripts --query "DBInstances[].DBInstanceStatus" --output text)

	if [ $describe = "available" ]
	then
		ip1=$(aws rds describe-db-instances --query "DBInstances[].Endpoint.Address" --output text)
		echo "Endpoint do RDS: "$ip1
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

mysql -u $usuario -p$senha -h $ip1<<FIM
CREATE DATABASE $db;
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'senhaDefault';
GRANT ALL PRIVILEGES ON $db.* TO 'wordpress'@'%';
FIM

#Instalação e configuração wordpress
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip


cat<<FINAL > /etc/apache2/sites-available.wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
FINAL

a2enmod rewrite
a2ensite wordpress
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch wordpress/.htaccess
cp -a wordpress/. /var/www/html/wordpress
systemctl restart apache2.service

cat<<ONE > /tmp/wp-config.php
<?php
define( 'DB_NAME', '$db' );
define( 'DB_USER', 'wordpress' );
define( 'DB_PASSWORD', 'senhaDefault' );
define( 'DB_HOST', '$ip1' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

 
ONE
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /tmp/wp-config.php

cat<<TWO >> /tmp/wp-config.php

\\\$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}
 

require_once ABSPATH . 'wp-settings.php';
TWO

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
rm client.sh




