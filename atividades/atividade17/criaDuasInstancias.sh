#!/bin/bash

#Declaração de variaveis e parametros
ipPublico=$(wget -qO- https://ipecho.net/plain)
imagem=ami-03d315ad33b9d49c4 
subnetId=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
chave=$1
usuario=$2
senha=$3
ip1=
ip2=

#Criaçaõ do Grupo de Segurança
grupoSecurity=$(aws ec2 create-security-group --group-name "atividade17" --description "Atividade17"  --output text)

#Configuração de portas
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 22 --cidr $ipPublico/32
aws ec2 authorize-security-group-ingress --group-name "atividade17" --protocol tcp --port 3306 --source-group $grupoSecurity

#Criando scripts da maquina1
cat<<EOF > serv.sh
#!/bin/bash 
apt update
apt-get -y install mysql-server

sed -i '32c\mysqlx-bind-address   = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '31c\bind-address          = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf

systemctl restart mysql.service

mysql<<FIM
CREATE DATABASE scripts;
CREATE USER '$usuario'@'%' IDENTIFIED BY $senha;
GRANT ALL PRIVILEGES ON scripts.* TO '$usuario'@'%';
FIM

EOF
chmod +x serv.sh

#Criando maquina de Banco de Dados
echo "Criando servidor de Bancos de Dados..."
idInstancia1=$(aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --security-group-ids $grupoSecurity --subnet $subnetId --key-name $chave --user-data file://serv.sh --query "Instances[0].InstanceId" --output text)
while [ true ]
do
	sleep 3
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



cat<<EOF > client.sh
#!/bin/bash
apt update
apt-get -y install mysql-client

echo "[client]" > /root/.my.cnf
echo "user="$usuario >> /root/.my.cnf
echo "password="$senha >> /root/.my.cnf
mysql -u $usuario scripts -h $ip1 <<MIAU
CREAT TABLE teste (atividade INT);
MIAU
EOF
chmod +x client.sh

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
                echo "IP Publico do Servidor de APlicação: "$ip2
                break
	else
		continue
	fi
done
rm serv.sh client.sh




