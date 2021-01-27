#!/bin/bash


tempo=$1
dir=$2

tamanhodir=$(ls $dir | wc -l)
list=$(ls $dir)
while [ true ]
do
	if [ $tamanhodir -ne $(ls $dir | wc -l) ]
	then
		if [ $tamanhodir -lt $(ls $dir | wc -l) ]  
		then
			for var in $(ls $dir)
			do
				if echo $list | grep '$var' &> /dev/null
				then
					continue
				else
					echo "[" $(date '+%d-%m-%Y %H:%M:%S') "] Alteração!" $tamanhodir "->"$(ls $dir | wc -l). "Adicionados: "$var >> dirSensores.log
					list=$(ls $dir)
					tamanhodir=$(ls $dir | wc -l)
					break
				fi
			done
		elif [ $tamanhodir -gt $(ls $dir | wc -l) ]
		then
			for v in $(echo $list)
			do
			if ls $dir | grep '$v' &> /dev/null
			then
				continue
			else
				echo "[" $(date '+%d-%m-%Y %H:%M:%S') "] Alteração!" $tamanhodir "->"$(ls $dir | wc -l). "Removido: "$v >> dirSensores.log
                        	list=$(ls $dir)
                        	tamanhodir=$(ls $dir | wc -l)
				break
			fi
			done
		fi
	fi
	sleep $tempo
done

