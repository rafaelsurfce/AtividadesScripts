#!/bin/bash

imagem=ami-03d315ad33b9d49c4 
grupoSecurity=$(aws ec2 create-security-group --group-name "atividade14" --description "para a atividade14" --output text)
subnetId=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
chave=$1

aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol tcp --port 22 --cidr 0.0.0.0/0
#aws ec2 authorize-security-group-ingress --group-id $grupoSecurity --protocol icmp --cidr 0.0.0.0/0



echo "Criando servidor..."
idInstancia=$(aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --security-group-ids $grupoSecurity --subnet $subnetId --key-name $chave --query "Instances[0].InstanceId" --output text)
ip=$(aws ec2 describe-instances --instance-id $idInstancia --query "Reservations[0].Instances[].PublicIpAddress" --output text)  

echo "Acesse: http://"$ip"/"



