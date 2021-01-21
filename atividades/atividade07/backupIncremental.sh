#!/bin/bash
# Correção: 0,0
dir1=$1
dir2=$2
data=$3
hora=$4
for v in $(ls ${dir1})
do
	if [ $(ls ${dir2} | grep $v) ]
	then
		continue
	else
		$( cp $dir1/$v $dir2/ ) 
	fi


done
