# Correção: OK. 1,0 ponto. Só se acostume a colocar #!/bin/bash
mkdir maiorque10

find -size +10M -exec  mv {} maiorque10/ \;

tar -czvf maiorque10.tar.gz maiorque10/

rm -rf maiorque10
