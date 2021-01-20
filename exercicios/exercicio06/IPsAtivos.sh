#!/bin/bash

end=$1
chmod +x analise.sh
./analise.sh $1 > saida.log &

rm saida.log
