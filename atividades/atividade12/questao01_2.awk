awk $5 ~ /sshd.*/ && $6 ~ /Accepted/ { print }
