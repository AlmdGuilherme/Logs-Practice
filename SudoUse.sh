#!/bin/bash

LOG_FILE="/var/log/auth.log"


"""
grep: Filtra entradas geradas especificamente pelo processo sudo contendo 'COMMAND='
awk: Extrai a data/hora ($1, $2, $3), o usuário que executou e o comando rodado
"""

grep "sudo:" "$LOG_FILE" | grep "COMMAND=" | awk '{
    data_hora = $1 " " $2 " " $3;
    
    # Busca quem executou o comando (campo 'USER=...')
    for (i=1; i<=NF; i++) {
        if ($i ~ /^COMMAND=/) {
            # Recorta a string do comando
            cmd = ""; for (j=i; j<=NF; j++) cmd = cmd " " $j;
            print data_hora " | Usuário executor: " $5 " | Comando:" cmd;
            break;
        }
    }
}'