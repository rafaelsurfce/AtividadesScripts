#!/bin/bash
# Correção: 1,0
n1=${1}
n2=${2}
n3=${3}


if [[ ${n1} != ?+([A-Za-z]) ]]
then
	if [[ ${n2} != ?+([A-Za-z]) ]]
	then
		if [[ ${n3} != ?+([A-Za-z]) ]]
		then
			if [ ${n1} -ge ${n2} ] && [ ${n1} -ge ${n3} ]
			then
				echo ${n1}
			elif [ ${n2} -ge ${n1} ] && [ ${n2} -ge ${n3} ]
                        then
                                echo ${n2}

			elif [ ${n3} -ge ${n1} ] && [ ${n3} -ge ${n2} ]
                        then
                                echo ${n3}
			fi
		else
			echo Opa!!! ${n3} não é numero

		fi
	else
		echo Opa!!! ${n2} não é numero
	fi
else 
	echo Opa!!! ${n1} não é numero
fi
