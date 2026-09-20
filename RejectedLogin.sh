#!/bin/bash

LOG_FILE="/var/log/auth.log"

"""
grep -E: Filtra falhas específicas como usuários inválidos ('Invalid user'), 
bloqueios de permissão ('Connection closed', 'PAM', 'Access denied', 'NOT in sudoers')

Exclui a verificação genérica de 'Failed password' para focar em problemas estruturais/permissão
"""

grep -E "Invalid user|not in sudoers|PAM.*Authentication failure|ROOT LOGIN REFUSED" "$LOG_FILE" | awk '{
    data_hora = $1 " " $2 " " $3;
    $1=""; $2=""; $3=""; # Remove a data/hora para imprimir a mensagem completa limpa
    print data_hora " - Motivo/Detalhe:" $0
}'