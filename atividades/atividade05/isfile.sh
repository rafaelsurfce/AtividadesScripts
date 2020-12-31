#!/bin/bash

end=$1

if test -d ${end}
then
	echo "É um diretorio"
	if test -r ${end}
	then 
		echo "Tem permisão de leitura"
	else
		echo "Não temm permissão de leitura"
	fi

	if test -w ${end}
        then 
                echo "Tem permisão de escrita"
        else
                echo "Não tem permissão de escrita"
	fi
	
elif test -f ${end}
then
	echo "É um arquivo regular"
        if test -r ${end}
        then 
                echo "Tem permisão de leitura"
        else
                echo "Não tem permissão de leitura"
        fi

        if test -w ${end}
        then 
                echo "Tem permisão de escrita"
        else
                echo "Não tem permissão de escrita"
        fi
else
	echo "Tipo de arquivo não reconhecido"
fi
