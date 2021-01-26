#!/bin/bash

tipo=$1
cor=$2
numero=$3
texto=$4



linha=$(echo $numero | cut -f1 -d',')
coluna=$(echo $numero | cut -f2 -d',')
if [ $tipo = "negrito" ]
then
	tput setaf $cor
	tput bold
	tput cup $linha $coluna
	echo "$texto"
elif [ $tipo = "reverso" ]
then
	tput setaf $cor
	tput smso
	tput cup $linha $coluna
	echo "$texto"
elif [ $tipo = "sublimado" ]
then
	tput setaf $cor
        tput smul
	tput cup $linha $coluna
        echo "$texto"
fi
