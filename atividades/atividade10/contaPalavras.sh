#!/bin/bash

read -p "Informe o arquivo: " arquivo

echo "" > palavras.txt

for var in $(cat $arquivo)
do
	if grep $var palavras.txt &> /dev/null
	then
		continue
	elif [[ $var != [[:alpha:]]*[....] ]]
	then
		printf $var:
		echo $(grep -wc $var $arquivo)
		echo $var >> palavras.txt
	fi
done
rm palavras.txt



