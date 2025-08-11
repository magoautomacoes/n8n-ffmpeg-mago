#!/bin/bash
set -o pipefail

# Cores para output
ciano="\e[36m"
verde="\e[32m"
amarelo="\e[33m"
vermelho="\e[31m"
reset="\e[0m"

# Função para exibir banner
show_banner() {
    echo -e "${ciano}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                Instalador FFmpeg para n8n                    ║"
    echo "║                    (Orion / Docker Swarm)                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${reset}"
}

# Função para exibir ajuda
show_help() {
    echo -e "${ciano}Uso:${reset}"
    echo "  sudo bash install.sh [opções]"
    echo ""
    echo -e "${ciano}Opções:${reset}"
    echo "  -h, --help     Exibe esta ajuda"
    echo "  -y, --yes      Instala automaticamente sem confirmação"
    echo "  -c, --check    Apenas verifica se FFmpeg está instalado"
    echo "  -u, --uninstall Desinstala FFmpeg"
    echo ""
    echo -e "${ciano}Exemplos:${reset}"
    echo "  sudo bash install.sh          # Instalação interativa"
    echo "  sudo bash install.sh -y       # Instalação automática"
    echo "  sudo bash install.sh -c       # Verificar instalação"
    echo "  sudo bash install.sh -u       # Desinstalar"
}

# Verificar se é root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${vermelho}❌ Este script precisa ser executado como root${reset}"
        echo -e "${amarelo}Use: sudo bash install.sh${reset}"
        exit 1
    fi
}

# Verificar se Docker está rodando
check_docker() {
    if ! docker info >/dev/null 2>&1; then
        echo -e "${vermelho}❌ Docker não está rodando ou não está acessível${reset}"
        exit 1
    fi
}

# Listar containers n8n
list_containers() {
    echo -e "${ciano}📋 Containers com 'n8n' no nome:${reset}"
    local containers=$(docker ps --format "{{.Names}}" | grep n8n)
    
    if [ -z "$containers" ]; then
        echo -e "${vermelho}❌ Nenhum container com 'n8n' no nome está em execução${reset}"
        echo -e "${amarelo}💡 Use 'docker ps' para verificar o nome do serviço no Swarm${reset}"
        return 1
    fi
    
    echo "$containers" | nl
    echo
    return 0
}

# Verificar se FFmpeg está instalado
check_ffmpeg() {
    local container_id="$1"
    if docker exec "$container_id" sh -c 'command -v ffmpeg >/dev/null 2>&1'; then
        local version=$(docker exec "$container_id" sh -c 'ffmpeg -version 2>/dev/null | head -n1' || echo "versão desconhecida")
        echo -e "${verde}✅ FFmpeg já está instalado: $version${reset}"
        return 0
    else
        echo -e "${amarelo}⚠️  FFmpeg não está instalado${reset}"
        return 1
    fi
}

# Desinstalar FFmpeg
uninstall_ffmpeg() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${amarelo}🗑️  Desinstalando FFmpeg do container: $container_name${reset}"
    
    if docker exec "$container_id" sh -c 'command -v apk >/dev/null 2>&1'; then
        echo -e "${amarelo}📦 Removendo via apk (Alpine)...${reset}"
        docker exec --user root "$container_id" sh -lc '
            apk del ffmpeg python3 py3-pip gcc python3-dev musl-dev curl 2>/dev/null || true
            apk del openssl libssl3 libcrypto3 2>/dev/null || true
        '
    elif docker exec "$container_id" sh -c 'command -v apt-get >/dev/null 2>&1'; then
        echo -e "${amarelo}📦 Removendo via apt (Debian/Ubuntu)...${reset}"
        docker exec --user root "$container_id" sh -lc '
            apt-get update
            DEBIAN_FRONTEND=noninteractive apt-get purge -y ffmpeg python3 python3-pip build-essential curl 2>/dev/null || true
            apt-get autoremove -y
            apt-get clean
        '
    fi
    
    echo -e "${verde}✅ FFmpeg desinstalado com sucesso${reset}"
}

# Instalar FFmpeg
install_ffmpeg() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${amarelo}🔍 Detectando base do container...${reset}"
    
    if docker exec "$container_id" sh -c 'command -v apk >/dev/null 2>&1'; then
        echo -e "${amarelo}🐧 Alpine detectado. Instalando FFmpeg...${reset}"
        docker exec --user root "$container_id" sh -lc '
            set -e
            echo "📦 Atualizando repositórios..."
            apk update
            echo "⬆️  Atualizando pacotes..."
            apk upgrade --no-cache
            echo "🔒 Alinhando OpenSSL..."
            apk add --no-cache --upgrade openssl libssl3 libcrypto3
            echo "🎬 Instalando FFmpeg e dependências..."
            apk add --no-cache ffmpeg python3 py3-pip gcc python3-dev musl-dev curl
            echo "🧹 Limpando cache..."
            apk cache clean
        '
    elif docker exec "$container_id" sh -c 'command -v apt-get >/dev/null 2>&1'; then
        echo -e "${amarelo}🐧 Debian/Ubuntu detectado. Instalando FFmpeg...${reset}"
        docker exec --user root "$container_id" sh -lc '
            set -e
            echo "📦 Atualizando repositórios..."
            apt-get update
            echo "🎬 Instalando FFmpeg e dependências..."
            DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
                ffmpeg python3 python3-pip build-essential curl
            echo "🧹 Limpando cache..."
            apt-get clean && rm -rf /var/lib/apt/lists/*
        '
    else
        echo -e "${vermelho}❌ Gerenciador de pacotes não suportado${reset}"
        return 1
    fi
    
    # Verificar instalação
    if check_ffmpeg "$container_id"; then
        echo -e "${verde}🎉 Instalação concluída com sucesso!${reset}"
        return 0
    else
        echo -e "${vermelho}❌ Falha na instalação do FFmpeg${reset}"
        return 1
    fi
}

# Função principal
main() {
    local auto_install=false
    local check_only=false
    local uninstall_mode=false
    
    # Parse argumentos
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -y|--yes)
                auto_install=true
                shift
                ;;
            -c|--check)
                check_only=true
                shift
                ;;
            -u|--uninstall)
                uninstall_mode=true
                shift
                ;;
            *)
                echo -e "${vermelho}❌ Opção desconhecida: $1${reset}"
                show_help
                exit 1
                ;;
        esac
    done
    
    show_banner
    check_root
    check_docker
    
    if ! list_containers; then
        exit 1
    fi
    
    # Selecionar container
    local container_name
    local container_id
    local count=$(docker ps --format "{{.Names}}" | grep n8n | wc -l)
    
    if [ "$count" -eq 1 ]; then
        container_name=$(docker ps --format "{{.Names}}" | grep n8n | head -n1)
        container_id=$(docker ps -q -f name="$container_name")
        echo -e "${amarelo}🎯 Container selecionado automaticamente: $container_name${reset}"
    else
        echo -e "${amarelo}📝 Digite o número do container (ou 'q' para sair):${reset}"
        read -p "> " opt || opt="q"
        [[ "$opt" =~ ^[Qq]$ ]] && echo -e "${amarelo}👋 Saindo...${reset}" && exit 0
        [[ "$opt" =~ ^[0-9]+$ ]] || { echo -e "${vermelho}❌ Opção inválida${reset}"; exit 1; }
        container_name=$(docker ps --format "{{.Names}}" | grep n8n | sed -n "${opt}p")
        [ -z "$container_name" ] && echo -e "${vermelho}❌ Container não encontrado${reset}" && exit 1
        container_id=$(docker ps -q -f name="$container_name")
    fi
    
    # Executar ação solicitada
    if [ "$check_only" = true ]; then
        echo -e "${ciano}🔍 Verificando FFmpeg no container: $container_name${reset}"
        check_ffmpeg "$container_id"
        exit $?
    elif [ "$uninstall_mode" = true ]; then
        if [ "$auto_install" = true ] || { echo -e "${amarelo}🗑️  Desinstalar FFmpeg do container: $container_name ? (s/n)${reset}"; read -p "> " ok && [[ "$ok" =~ ^[Ss]$ ]]; }; then
            uninstall_ffmpeg "$container_id" "$container_name"
        else
            echo -e "${amarelo}❌ Operação cancelada${reset}"
        fi
    else
        # Modo instalação
        if check_ffmpeg "$container_id"; then
            echo -e "${amarelo}1) Desinstalar  2) Escolher outro  3) Sair${reset}"
            read -p "> " op || op="3"
            case "$op" in
                1) uninstall_ffmpeg "$container_id" "$container_name" ;;
                2) echo -e "${amarelo}🔄 Execute o script novamente para escolher outro container${reset}" ;;
                3) echo -e "${amarelo}👋 Saindo...${reset}" ;;
                *) echo -e "${vermelho}❌ Opção inválida${reset}"; exit 1 ;;
            esac
        else
            if [ "$auto_install" = true ] || { echo -e "${amarelo}🎬 Instalar FFmpeg no container: $container_name ? (s/n)${reset}"; read -p "> " ok && [[ "$ok" =~ ^[Ss]$ ]]; }; then
                install_ffmpeg "$container_id" "$container_name"
            else
                echo -e "${amarelo}❌ Operação cancelada${reset}"
            fi
        fi
    fi
}

# Executar função principal
main "$@"
