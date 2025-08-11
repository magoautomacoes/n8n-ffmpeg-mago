
---

## 📄 `install.sh`
```bash
#!/bin/bash
set -o pipefail

# precisa ser root
if [ "$EUID" -ne 0 ]; then 
  echo "Este script precisa ser executado como root (use: sudo bash install.sh)"; exit 1
fi

ciano="\e[36m"; verde="\e[32m"; amarelo="\e[33m"; vermelho="\e[31m"; reset="\e[0m"
echo -e "${ciano}Instalador FFmpeg para n8n (Orion/Swarm)${reset}\n"

list() {
  echo -e "${ciano}Containers com 'n8n' no nome:${reset}"
  docker ps --format "{{.Names}}" | grep n8n | nl || true
  echo
}

uninstall() {
  local id="$1"
  if docker exec "$id" sh -c 'command -v apk >/dev/null 2>&1'; then
    docker exec --user root "$id" sh -lc 'apk del ffmpeg || true'
  elif docker exec "$id" sh -c 'command -v apt-get >/dev/null 2>&1'; then
    docker exec --user root "$id" sh -lc 'apt-get update && DEBIAN_FRONTEND=noninteractive apt-get purge -y ffmpeg || true'
  fi
}

install_ffmpeg() {
  local id="$1"

  # já tem?
  if docker exec "$id" sh -c 'command -v ffmpeg >/dev/null 2>&1'; then
    echo -e "${verde}FFmpeg já está instalado neste container.${reset}"
    echo -e "${amarelo}1) Desinstalar  2) Escolher outro  3) Sair${reset}"
    read -p "> " op || op="3"
    case "$op" in
      1) uninstall "$id" && echo -e "${verde}Desinstalado (se existia).${reset}" ;;
      2) return 2 ;;
      3) exit 0 ;;
      *) echo -e "${vermelho}Opção inválida.${reset}"; exit 1 ;;
    esac
    return 0
  fi

  echo -e "${amarelo}Detectando base do container (Alpine x Debian/Ubuntu)...${reset}"
  if docker exec "$id" sh -c 'command -v apk >/dev/null 2>&1'; then
    echo -e "${amarelo}Alpine detectado. Alinhando OpenSSL e instalando FFmpeg...${reset}"
    docker exec --user root "$id" sh -lc '
      set -e
      apk update
      apk upgrade --no-cache
      apk add --no-cache --upgrade openssl libssl3 libcrypto3
      apk add --no-cache ffmpeg python3 py3-pip gcc python3-dev musl-dev curl
    '
  elif docker exec "$id" sh -c 'command -v apt-get >/dev/null 2>&1'; then
    echo -e "${amarelo}Debian/Ubuntu detectado. Instalando FFmpeg...${reset}"
    docker exec --user root "$id" sh -lc '
      set -e
      apt-get update
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ffmpeg python3 python3-pip build-essential curl
      apt-get clean && rm -rf /var/lib/apt/lists/*
    '
  else
    echo -e "${vermelho}Gerenciador de pacotes não suportado dentro do container.${reset}"
    return 1
  fi

  echo -e "${verde}Instalação concluída!${reset}"
  return 0
}

# seleção do container
list
if ! docker ps --format "{{.Names}}" | grep -q n8n; then
  echo -e "${vermelho}Nenhum container com 'n8n' no nome está em execução.${reset}"
  echo -e "${amarelo}Use 'docker ps' para verificar o nome do serviço no Swarm.${reset}"
  exit 1
fi

count=$(docker ps --format "{{.Names}}" | grep n8n | wc -l)
if [ "$count" -eq 1 ]; then
  cname=$(docker ps --format "{{.Names}}" | grep n8n | head -n1)
  cid=$(docker ps -q -f name="$cname")
  echo -e "${amarelo}Container selecionado automaticamente: $cname${reset}"
else
  echo -e "${amarelo}Digite o número do container (ou 'q' para sair):${reset}"
  read -p "> " opt || opt="q"
  [[ "$opt" =~ ^[Qq]$ ]] && echo -e "${amarelo}Saindo...${reset}" && exit 0
  [[ "$opt" =~ ^[0-9]+$ ]] || { echo -e "${vermelho}Opção inválida.${reset}"; exit 1; }
  cname=$(docker ps --format "{{.Names}}" | grep n8n | sed -n "${opt}p")
  [ -z "$cname" ] && echo -e "${vermelho}Container não encontrado.${reset}" && exit 1
  cid=$(docker ps -q -f name="$cname")
fi

echo -e "${amarelo}Instalar FFmpeg no container: $cname ? (s/n)${reset}"
read -p "> " ok || ok="n"
if [[ "$ok" =~ ^[Ss]$ ]]; then
  while true; do
    install_ffmpeg "$cid"
    rc=$?
    if [ $rc -eq 2 ]; then
      list
      echo -e "${amarelo}Escolha outro container (ou 'q' para sair):${reset}"
      read -p "> " opt || opt="q"
      [[ "$opt" =~ ^[Qq]$ ]] && echo -e "${amarelo}Saindo...${reset}" && exit 0
      [[ "$opt" =~ ^[0-9]+$ ]] || { echo -e "${vermelho}Opção inválida.${reset}"; exit 1; }
      cname=$(docker ps --format "{{.Names}}" | grep n8n | sed -n "${opt}p")
      [ -z "$cname" ] && echo -e "${vermelho}Container não encontrado.${reset}" && exit 1
      cid=$(docker ps -q -f name="$cname")
      echo -e "${amarelo}Instalar FFmpeg no container: $cname ? (s/n)${reset}"
      read -p "> " ok2 || ok2="n"
      [[ "$ok2" =~ ^[Ss]$ ]] && continue || { echo -e "${amarelo}Cancelado.${reset}"; exit 0; }
    else
      exit $rc
    fi
  done
else
  echo -e "${amarelo}Operação cancelada.${reset}"
fi
