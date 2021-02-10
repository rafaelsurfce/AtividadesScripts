BEGIN{
	total = 0
}
$2 >= 5000 { total = total + $2 }
END{

	print "SOMA TOTAL:", total
}
