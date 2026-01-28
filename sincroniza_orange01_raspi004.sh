#!/bin/bash
# Script de sincronização diária com logging no syslog
# Autor: pdsilva
# Agendamento: 0 1 * * * /usr/local/bin/sincroniza_docs.sh

# Configurações
LOG_ID="rsync-docs"
SSH_USER="pdsilva"
SSH_HOST="192.168.1.10"
SSH_DEST="/home/pdsilva/Documents"

# Array com os diretórios para sincronizar
DIRETORIOS=(
    "0000_Projetos"
    "0000_Videos" 
    "0000_Eletronica"
    "00000_Datasheets"
    "Articles"
    "Music"
    "0000_Pictures"
    "Ebooks"
    "0000_DocPessoais"
    "0000_Equipamentos"
    "bin_windows"
    "0000_Mecanica"
)

# Função para log no syslog
log_syslog() {
    local nivel=$1
    local mensagem=$2
    logger -t "$LOG_ID" -p "user.$nivel" "$mensagem"
}

# Função para sincronizar um diretório
sincroniza_dir() {
    local dir="$1"
    local origem="/home/pdsilva/Documents/$dir"
    local destino="$SSH_USER@$SSH_HOST:$SSH_DEST/$dir/"
    
    log_syslog "info" "INÍCIO: Sincronizando $dir"
    
    # Verifica se diretório de origem existe
    if [ ! -d "$origem" ]; then
        log_syslog "err" "ERRO: Diretório $origem não existe"
        return 1
    fi
    
   
    # Executa rsync COM --delete
    rsync -av --delete --stats \
        --timeout=300 \
        "$origem/" "$destino" >> /var/log/rsync.log 2>&1
    
    local resultado=$?
    
    if [ $resultado -eq 0 ]; then
        log_syslog "info" "SUCESSO: $dir sincronizado"
    else
        log_syslog "err" "ERRO $resultado: Falha ao sincronizar $dir"
    fi
    
    return $resultado
}

# MAIN
main() {
    log_syslog "info" "====== INÍCIO DA SINCRONIZAÇÃO DIÁRIA ======"
    
    # Cria arquivo de lock para evitar execuções simultâneas
    LOCK_FILE="/tmp/sincroniza_docs.lock"
    if [ -f "$LOCK_FILE" ]; then
        log_syslog "err" "ERRO: Processo já em execução (lock file existe)"
        exit 1
    fi
    trap "rm -f $LOCK_FILE" EXIT
    echo $$ > "$LOCK_FILE"
    
    # Contadores
    sucessos=0
    falhas=0
    total=${#DIRETORIOS[@]}
    
    # Sincroniza cada diretório (UM POR VEZ, não em paralelo!)
    for i in "${!DIRETORIOS[@]}"; do
        dir="${DIRETORIOS[$i]}"
        log_syslog "info" "Progresso: $((i+1))/$total - Diretório: $dir"
        
        if sincroniza_dir "$dir"; then
            ((sucessos++))
        else
            ((falhas++))
        fi
        
        # Pequena pausa entre diretórios
        sleep 2
    done
    
    # Resumo final
    log_syslog "info" "RESUMO: $sucessos/$total diretórios sincronizados com sucesso"
    
    if [ $falhas -eq 0 ]; then
        log_syslog "info" "====== SINCRONIZAÇÃO CONCLUÍDA COM SUCESSO ======"
    else
        log_syslog "warning" "====== SINCRONIZAÇÃO CONCLUÍDA COM $falhas FALHA(S) ======"
    fi
    
    rm -f "$LOCK_FILE"
}

# Executa o script
main "$@"

