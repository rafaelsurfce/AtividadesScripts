#!/bin/bash

ip=$1

echo "INICIO" >> $1.txt
for v in $(seq 1 254)
do
	ping -c 1 ${1}$v
        if [ $? -eq 0 ]
        then
                echo "${1}$v on" >> $1.txt
        fi
done
echo "FIM" >>$1.txt

