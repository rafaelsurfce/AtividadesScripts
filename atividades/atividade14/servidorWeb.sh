#!/bin/bash

imagem=ami-03d315ad33b9d49c4 
grupoSecurity=$(aws ec2 describe-security-groups --query "SecurityGroups[0].GroupId" --output text)
subnetId=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
chave=$1

echo "Criando servidor..."
idInstancia=$(aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --security-group-ids $grupoSecurity --subnet $subnetId --key-name $chave --query "Instances[0].InstanceId" --output text)
ip=$(aws ec2 describe-instances --instance-id $idInstancia --query "Reservations[0].Instances[].PublicIpAddress" --output text)  

echo "Acesse: http://"$ip"/"



