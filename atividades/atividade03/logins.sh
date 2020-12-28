# Correção: 1,0
#1
grep -v 'sshd' auth.log.1

#2
grep -E 'sshd[[[:digit:]]*]:[[:space:]]*Accepted' auth.log.1

#3

grep -E 'sshd[[[:digit:]]*]:[[:space:]]*Disconnected from authenticating user root' auth.log.1 

#4

grep -E 'Dec[[:space:]]*4[[:space:]]*(18.*|19:00.*).*sshd[[[:digit:]]*]:[[:space:]]*Accepted' auth.log.1

