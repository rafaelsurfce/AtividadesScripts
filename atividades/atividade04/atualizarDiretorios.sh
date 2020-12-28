# Correção: 0,5. A pasta /home/ubuntu vira /srv/ubuntu, o que não deve acontecer.
sed 's/home/srv/g' ../../../../../../etc/passwd | sed 's/alunos/students/g' > passwd.new

