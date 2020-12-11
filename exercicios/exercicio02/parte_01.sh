# Correção: 0,5
#1

#2
grep -E '\bA' emailsordenados.txt

#3
grep -E '.br$' emailsordenados.txt

#4 Cadê o @?
grep -E '[0-9][^0-9 ]' emailsordenados.txt
