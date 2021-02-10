#Correção: OK
BEGIN {
	total = 0
}
$NF ~/@gmail.com/{
	total = total + 1
}
END {
	print "Quantidade:", total
}




