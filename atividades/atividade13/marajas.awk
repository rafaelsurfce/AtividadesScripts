NR > 2{
	if ($3 > maiorSalario[$2]){
		maiorSalario[$2] = $3;
		professor[$2]=$1
	}
}
END {
	for (curso in maiorSalario){
		printf "%s:%+8s,%+8s\n", curso,professor[curso],maiorSalario[curso]
	}   
}
