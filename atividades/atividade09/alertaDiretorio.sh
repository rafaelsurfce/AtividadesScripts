#!/bin/bash
# Correção: 2,0. Não captura os nomes.


tempo=$1
dir=$2

tamanhodir=$(ls $dir | wc -l)
while [ true ]
do
		if [ $tamanhodir -lt $(ls $dir | wc -l) ]
		then
			echo "[" $(date '+%d-%m-%Y %H:%M:%S') "] Alteração!" $tamanhodir "->"$(ls $dir | wc -l). "Adicionados: " >> dirSensores.log
			tamanhodir=$(ls $dir | wc -l)
		elif [ $tamanhodir -gt $(ls $dir | wc -l) ]
		then
			echo "[" $(date '+%d-%m-%Y %H:%M:%S') "] Alteração!" $tamanhodir "->"$(ls $dir | wc -l). "Removido: " >> dirSensores.log
                        tamanhodir=$(ls $dir | wc -l)
		fi
	sleep $tempo
done
