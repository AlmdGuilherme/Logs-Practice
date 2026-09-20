#!/bin/bash

LOG_FILE="/var/log/auth.log"

"""
grep -E: Busca eventos de sessão aberta com sucesso para usuários ('Accepted password' ou 'session opened')
awk: Formata e exibe os campos de Data/Hora ($1, $2, $3) e o Usuário correspondente
"""

grep -E "Accepted (password|publickey)|session opened for user" "$LOG_FILE" | awk '{
    # Pega a data e hora nas colunas
    data_hora = $1 " " $2 " " $3;
    
    # Se for evento SSH (Accepted password/publickey)
    if ($0 ~ /Accepted/) {
        for (i=1; i<=NF; i++) {
            if ($i == "for") { print data_hora " - Usuário: " $(i+1); break }
        }
    } 
    # Se for abertura de sessão local (su/sudo/PAM)
    else if ($0 ~ /session opened for user/) {
        for (i=1; i<=NF; i++) {
            if ($i == "user") { print data_hora " - Usuário: " $(i+1); break }
        }
    }
}'