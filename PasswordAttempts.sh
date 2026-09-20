#!/bin/bash

# Define o arquivo de log (ajuste para /var/log/secure se usar RHEL/CentOS)
LOG_FILE="/var/log/auth.log"

"""
 Filtra linhas relativas a falhas de senha ('Failed password') e
 extrai o campo correspondente ao nome do usuário 
 (trata o caso com o termo 'for invalid user')
"""
grep "Failed password" "$LOG_FILE" | awk '{   
    for (i=1; i<=NF; i++) {
        if ($i == "for") {
            if ($(i+1) == "invalid") {
                print $(i+2)
            } else {
                print $(i+1)
            }
            break
        }
    }
}' | sort | uniq -c | sort -nr

"""
 sort: Ordena os nomes para que o 'uniq' consiga agrupar os nomes iguais
 uniq -c: Agrupa e conta a ocorrência de cada usuário
 sort -nr: Ordena o resultado numérico de forma decrescente (do maior número de falhas para o menor)
"""