#!/bin/bash

arquivo=${1}

echo "Relatório de Latência"
for i in $(cat ${arquivo})
do
	 ping -c 5 "${i}" >> ping.txt
	echo "${i} $(grep avg ping.txt | cut -f5 -d'/')ms"
	rm ping.txt 
done
