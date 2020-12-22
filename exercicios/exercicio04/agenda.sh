#!/bin/bash

comando=$1
nome=$2
email=$3

if  test ${comando} = 'adicionar'
then
	echo ${nome}:${email} >> usuarios.db
	echo "Contato ${nome} adicionado com sucesso"
fi


if test ${comando} = 'listar'
then
	cat usuarios.db
fi
