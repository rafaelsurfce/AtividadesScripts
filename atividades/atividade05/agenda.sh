#!/bin/bash
comando=$1
nome=$2
email=$3

if  test ${comando} = 'adicionar'
then
        echo ${nome}:${email} >> usuarios.db
        echo "Contato ${nome} adicionado com sucesso"

elif test ${comando} = 'listar'
then
        cat usuarios.db


elif test ${comando} = 'remover'
then
	sed -i '/'${nome}'/d' usuarios.db
	
	echo " Removido com sucesso"
else
	echo " Comando desconhecido"
fi
