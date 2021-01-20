#!/bin/bash

ip=$1

echo "Iniciando analise da rede ${1}0/24"
echo "INICIO" >> $1.txt
for v in $(seq 1 255)
do
	ping -c 1 ${1}$v
        if [ $(echo $?)==0 ]
        then
                echo "${1}$v on" >> $1.txt
        fi
done
echo "FIM" >>$1.txt

