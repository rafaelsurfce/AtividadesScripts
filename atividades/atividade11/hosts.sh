#!/bin/bash
# Não funciona, diz o que é para ser veito, mas não faz. 
cont=1
ip=null
nome=null
touch hosts.db
getopts "a:i:r:d:l" OPTVAR

case $OPTVAR in
a)
	cont=0
	nome=$OPTARG
	;;
i)
	cont=0
	ip=$OPTARG
	;;
d)
	cont=0
	echo 'ta excluindo' 
	sed '/'$OPTARG'.*/d' hosts.db
	;;
l)
	cont=0
	echo 'ta listando'
	cat hosts.db
	;;
r)
	grep .*$OPTARG hosts.db | cut -f1 -d' '
	;;
esac
if [[ $nome != null  ]] && [[ $ip != null ]]
then
	echo '$nome $ip' >> hosts.db
	nome=null
	ip=null
fi
