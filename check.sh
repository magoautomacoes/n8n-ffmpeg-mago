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
    echo "║                Verificador FFmpeg para n8n                   ║"
    echo "║                    (Orion / Docker Swarm)                    ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${reset}"
}

# Verificar se Docker está rodando
check_docker() {
    echo -e "${ciano}🔍 Verificando Docker...${reset}"
    if ! docker info >/dev/null 2>&1; then
        echo -e "${vermelho}❌ Docker não está rodando ou não está acessível${reset}"
        return 1
    fi
    echo -e "${verde}✅ Docker está rodando${reset}"
    return 0
}

# Listar containers n8n
list_containers() {
    echo -e "${ciano}📋 Containers n8n encontrados:${reset}"
    local containers=$(docker ps --format "{{.Names}}" | grep n8n)
    
    if [ -z "$containers" ]; then
        echo -e "${vermelho}❌ Nenhum container com 'n8n' no nome está em execução${reset}"
        return 1
    fi
    
    echo "$containers" | nl
    echo
    return 0
}

# Verificar informações do container
check_container_info() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${ciano}📊 Informações do container: $container_name${reset}"
    
    # Informações básicas
    local image=$(docker inspect --format='{{.Config.Image}}' "$container_id")
    local status=$(docker inspect --format='{{.State.Status}}' "$container_id")
    local created=$(docker inspect --format='{{.Created}}' "$container_id")
    
    echo -e "${amarelo}🖼️  Imagem:${reset} $image"
    echo -e "${amarelo}📈 Status:${reset} $status"
    echo -e "${amarelo}📅 Criado:${reset} $created"
    
    # Detectar sistema operacional
    if docker exec "$container_id" sh -c 'command -v apk >/dev/null 2>&1'; then
        echo -e "${amarelo}🐧 Sistema:${reset} Alpine Linux"
        local os_version=$(docker exec "$container_id" sh -c 'cat /etc/alpine-release 2>/dev/null' || echo "versão desconhecida")
        echo -e "${amarelo}📋 Versão Alpine:${reset} $os_version"
    elif docker exec "$container_id" sh -c 'command -v apt-get >/dev/null 2>&1'; then
        echo -e "${amarelo}🐧 Sistema:${reset} Debian/Ubuntu"
        local os_version=$(docker exec "$container_id" sh -c 'cat /etc/os-release 2>/dev/null | grep PRETTY_NAME' || echo "versão desconhecida")
        echo -e "${amarelo}📋 Versão OS:${reset} $os_version"
    else
        echo -e "${amarelo}🐧 Sistema:${reset} Desconhecido"
    fi
    
    echo
}

# Verificar FFmpeg
check_ffmpeg_installation() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${ciano}🎬 Verificando FFmpeg no container: $container_name${reset}"
    
    # Verificar se FFmpeg está instalado
    if docker exec "$container_id" sh -c 'command -v ffmpeg >/dev/null 2>&1'; then
        echo -e "${verde}✅ FFmpeg está instalado${reset}"
        
        # Obter versão
        local version=$(docker exec "$container_id" sh -c 'ffmpeg -version 2>/dev/null | head -n1' || echo "versão desconhecida")
        echo -e "${amarelo}📋 Versão:${reset} $version"
        
        # Verificar codecs disponíveis
        echo -e "${amarelo}🔧 Codecs disponíveis:${reset}"
        docker exec "$container_id" sh -c 'ffmpeg -codecs 2>/dev/null | head -n10' || echo "Não foi possível listar codecs"
        
        # Teste básico
        echo -e "${amarelo}🧪 Teste básico:${reset}"
        if docker exec "$container_id" sh -c 'ffmpeg -f lavfi -i testsrc=duration=1:size=320x240:rate=1 -f null - 2>/dev/null'; then
            echo -e "${verde}✅ Teste de codificação bem-sucedido${reset}"
        else
            echo -e "${vermelho}❌ Falha no teste de codificação${reset}"
        fi
        
    else
        echo -e "${vermelho}❌ FFmpeg não está instalado${reset}"
        
        # Verificar se há pacotes relacionados
        echo -e "${amarelo}🔍 Verificando pacotes relacionados...${reset}"
        
        if docker exec "$container_id" sh -c 'command -v apk >/dev/null 2>&1'; then
            docker exec "$container_id" sh -c 'apk list | grep -i ffmpeg' || echo "Nenhum pacote FFmpeg encontrado"
        elif docker exec "$container_id" sh -c 'command -v apt-get >/dev/null 2>&1'; then
            docker exec "$container_id" sh -c 'dpkg -l | grep -i ffmpeg' || echo "Nenhum pacote FFmpeg encontrado"
        fi
    fi
    
    echo
}

# Verificar dependências
check_dependencies() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${ciano}📦 Verificando dependências no container: $container_name${reset}"
    
    local deps=("python3" "curl" "gcc")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if docker exec "$container_id" sh -c "command -v $dep >/dev/null 2>&1"; then
            echo -e "${verde}✅ $dep está instalado${reset}"
        else
            echo -e "${vermelho}❌ $dep não está instalado${reset}"
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${amarelo}⚠️  Dependências faltando: ${missing_deps[*]}${reset}"
    else
        echo -e "${verde}✅ Todas as dependências estão instaladas${reset}"
    fi
    
    echo
}

# Verificar espaço em disco
check_disk_space() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${ciano}💾 Verificando espaço em disco no container: $container_name${reset}"
    
    docker exec "$container_id" sh -c 'df -h /' 2>/dev/null || echo "Não foi possível verificar espaço em disco"
    echo
}

# Verificar logs do container
check_container_logs() {
    local container_id="$1"
    local container_name="$2"
    
    echo -e "${ciano}📋 Últimos logs do container: $container_name${reset}"
    
    docker logs --tail 10 "$container_id" 2>/dev/null || echo "Não foi possível acessar logs"
    echo
}

# Função principal
main() {
    show_banner
    
    if ! check_docker; then
        exit 1
    fi
    
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
    
    echo -e "${ciano}🔍 Iniciando verificação completa...${reset}"
    echo
    
    check_container_info "$container_id" "$container_name"
    check_ffmpeg_installation "$container_id" "$container_name"
    check_dependencies "$container_id" "$container_name"
    check_disk_space "$container_id" "$container_name"
    
    echo -e "${verde}✅ Verificação concluída!${reset}"
    echo -e "${amarelo}💡 Para instalar FFmpeg, execute: sudo bash install.sh${reset}"
}

# Executar função principal
main "$@"
