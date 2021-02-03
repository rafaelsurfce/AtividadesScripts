#/bin/bash

trap "echo 'Script encerrado';exit" 2



tempo(){
clear
echo "RESULTADO:"
uptime
echo ' '
}
ultimasMensagens(){
clear
echo "RESULTADO:"
dmesg | tail -n 10
echo ' '
}
memoriaVirtual(){
clear
echo "RESULTADO:"
vmstat 1 10
echo ' '
}
usoCPU(){
clear
echo "RESULTADO:"
mpstat -P ALL 1 5
echo ' '
}
usoCPUProcessos(){
clear
echo "RESULTADO:"
pidstat 1 5
echo ' '
}
memoriaFisica(){
clear
echo "RESULTADO:"
free -m
echo ' '
}
menu()
{
echo '1 Tempo ligado|' 
echo '2 Ultimas Mensagens do Kernel|' 
echo '3 Memoria Virtual|' 
echo '4 Uso da CPU por núcleo|' 
echo '5 Uso da CPU por processos|' 
echo '6 Uso da Memória fisica| '
echo ' caso deseja sair pressione CTRL + C'
echo ' '
read -p 'Informe o numero da opção desejada: ' opcao
}


while true 
do
menu
        if [ $opcao -eq 1 ]
        then
                tempo
        elif [ $opcao -eq 2 ]
        then
                ultimasMensagens
        elif [ $opcao -eq 3 ]
        then
                memoriaVirtual
        elif [ $opcao -eq 4 ]
        then
                usoCPU
        elif [ $opcao -eq 5 ]
        then
                usoCPUProcessos
        elif [ $opcao -eq 6 ]
        then
                memoriaFisica
        else
                echo 'Opção invalida'
        fi 

done











