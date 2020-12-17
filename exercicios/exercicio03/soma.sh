#!/bin/bash
# Correção: Chegou até o terceiro comando.
#1
cat compras.txt | cut -f2 -d' ' | tr '\n' '+' | sed 's/+$/\n/' | bc
#4
 
