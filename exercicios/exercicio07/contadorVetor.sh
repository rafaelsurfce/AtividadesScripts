#!/bin/bash
# Correção: 0,5
numeros=()
indice=0
while [ true ]
do
	read -p  "Digite um numero para armazenar no vetor, ou q para listar o tamanho do vetor: " comando
	if [[ $comando != "q" ]]
	then
		numeros[$indice]=$comando
		indice=$((indice+1))
		echo "numero adicionado com sucesso"
	elif [[ $comando == "q" ]]
	then
		echo "tamanho é ${#numeros[@]}"
		break
	else
	
		echo "comando nao reconhecido"
	fi
	
done
