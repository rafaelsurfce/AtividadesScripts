#!/bin/bash

end=$1
chmod +x analise.sh
echo "Iniciando analise da rede ${1}0/24"
./analise.sh $1 > /dev/null &

