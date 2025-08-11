#!/bin/bash
set -o pipefail

# Cores para output
ciano="\e[36m"
verde="\e[32m"
amarelo="\e[33m"
vermelho="\e[31m"
reset="\e[0m"

echo -e "${ciano}🧪 Teste Rápido - FFmpeg para n8n${reset}"
echo "=================================="

# Verificar se os scripts existem
echo -e "${amarelo}📁 Verificando arquivos...${reset}"
if [ -f "install.sh" ]; then
    echo -e "${verde}✅ install.sh encontrado${reset}"
else
    echo -e "${vermelho}❌ install.sh não encontrado${reset}"
    exit 1
fi

if [ -f "check.sh" ]; then
    echo -e "${verde}✅ check.sh encontrado${reset}"
else
    echo -e "${vermelho}❌ check.sh não encontrado${reset}"
    exit 1
fi

if [ -f "README.md" ]; then
    echo -e "${verde}✅ README.md encontrado${reset}"
else
    echo -e "${vermelho}❌ README.md não encontrado${reset}"
fi

if [ -f "config.json" ]; then
    echo -e "${verde}✅ config.json encontrado${reset}"
else
    echo -e "${vermelho}❌ config.json não encontrado${reset}"
fi

# Verificar se Docker está disponível
echo -e "${amarelo}🐳 Verificando Docker...${reset}"
if command -v docker >/dev/null 2>&1; then
    echo -e "${verde}✅ Docker encontrado${reset}"
    docker_version=$(docker --version)
    echo -e "${amarelo}📋 Versão: $docker_version${reset}"
else
    echo -e "${vermelho}❌ Docker não encontrado${reset}"
fi

# Verificar se há containers n8n rodando
echo -e "${amarelo}🔍 Verificando containers n8n...${reset}"
if command -v docker >/dev/null 2>&1; then
    n8n_containers=$(docker ps --format "{{.Names}}" | grep n8n | wc -l)
    if [ "$n8n_containers" -gt 0 ]; then
        echo -e "${verde}✅ $n8n_containers container(s) n8n encontrado(s)${reset}"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep n8n
    else
        echo -e "${amarelo}⚠️  Nenhum container n8n em execução${reset}"
    fi
fi

# Verificar permissões dos scripts
echo -e "${amarelo}🔐 Verificando permissões...${reset}"
if [ -x "install.sh" ]; then
    echo -e "${verde}✅ install.sh é executável${reset}"
else
    echo -e "${amarelo}⚠️  install.sh não é executável (execute: chmod +x install.sh)${reset}"
fi

if [ -x "check.sh" ]; then
    echo -e "${verde}✅ check.sh é executável${reset}"
else
    echo -e "${amarelo}⚠️  check.sh não é executável (execute: chmod +x check.sh)${reset}"
fi

# Verificar se é root
echo -e "${amarelo}👤 Verificando permissões de usuário...${reset}"
if [ "$EUID" -eq 0 ]; then
    echo -e "${verde}✅ Executando como root${reset}"
else
    echo -e "${amarelo}⚠️  Não está executando como root (use sudo para instalar)${reset}"
fi

echo ""
echo -e "${ciano}🎯 Próximos passos:${reset}"
echo "1. Para instalar FFmpeg: sudo bash install.sh"
echo "2. Para verificar status: sudo bash check.sh"
echo "3. Para verificar apenas FFmpeg: sudo bash install.sh -c"
echo "4. Para desinstalar: sudo bash install.sh -u"

echo ""
echo -e "${verde}✅ Teste concluído!${reset}"
