#!/bin/bash

#1
cat compras.txt
echo " "
#2
cut -f2 -d' ' compras.txt
echo " "
#3
cut -f2 -d' ' compras.txt | tr '\n' '+'
#4
 
