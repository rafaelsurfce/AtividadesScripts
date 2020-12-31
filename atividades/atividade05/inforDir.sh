#!/bin/bash

end=$1

if test -d ${end}
then
	echo  O diretorio ${end} ocupa $(du -hsk ${end} | sed 's/[[:space:]].*.*/ /') kilobytes e tem $( ls ${end} |wc -l) itens


else

	echo Opa!!! ${end} não é um diretorio    	
fi
