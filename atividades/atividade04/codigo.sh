#!/bin/bash
# Correção: 1,0

#1
sed -i 's/\/bin\/python/\/usr\/bin\/python3/g' atividade04.py
#2
sed -i 's/nota/NOTA/g' atividade04.py | sed -i 's/Final/FINAL/g' atividade04.py
#3
sed -i '3a \import time' atividade04.py 
#4
sed -i '10a \   print(time.ctime())' atividade04.py 
 


