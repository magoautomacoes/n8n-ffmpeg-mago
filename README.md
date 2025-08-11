# 🎬 Instalador FFmpeg para n8n (Orion / Docker Swarm)

Este projeto fornece scripts automatizados para instalar o **FFmpeg** dentro de containers **n8n** gerenciados pelo **Orion Design** no ambiente **Docker Swarm**.

## 🚀 Características

- ✅ **Detecção automática** do sistema operacional do container (Alpine vs Debian/Ubuntu)
- ✅ **Instalação inteligente** com tratamento de dependências
- ✅ **Verificação completa** do status da instalação
- ✅ **Interface amigável** com cores e emojis
- ✅ **Múltiplas opções** de execução (interativa, automática, verificação)
- ✅ **Tratamento de erros** robusto
- ✅ **Compatibilidade** com Docker Swarm

## 📋 Pré-requisitos

- Docker instalado e rodando
- Acesso root (sudo)
- Container n8n em execução
- Conectividade com internet (para download dos pacotes)

## 🛠️ Instalação

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd n8n-ffmpeg-mago
```

### 2. Torne os scripts executáveis
```bash
chmod +x install.sh check.sh
```

### 3. Execute a instalação
```bash
sudo bash install.sh
```

## 📖 Como usar

### Instalação Interativa (Recomendado)
```bash
sudo bash install.sh
```
O script irá:
- Listar todos os containers n8n disponíveis
- Permitir seleção do container (se houver múltiplos)
- Detectar automaticamente o sistema operacional
- Instalar FFmpeg e dependências
- Verificar a instalação

### Instalação Automática
```bash
sudo bash install.sh -y
```
Instala automaticamente sem confirmações.

### Verificar Status
```bash
sudo bash check.sh
```
Executa uma verificação completa do sistema:
- Status do Docker
- Informações do container
- Verificação do FFmpeg
- Dependências instaladas
- Espaço em disco
- Logs do container

### Verificar Apenas FFmpeg
```bash
sudo bash install.sh -c
```
Verifica rapidamente se o FFmpeg está instalado.

### Desinstalar FFmpeg
```bash
sudo bash install.sh -u
```
Remove o FFmpeg e suas dependências do container.

## 🔧 Opções Disponíveis

| Opção | Descrição |
|-------|-----------|
| `-h, --help` | Exibe ajuda |
| `-y, --yes` | Instala automaticamente sem confirmação |
| `-c, --check` | Apenas verifica se FFmpeg está instalado |
| `-u, --uninstall` | Desinstala FFmpeg |

## 🐧 Sistemas Suportados

### Alpine Linux
- Instala via `apk`
- Alinha OpenSSL antes da instalação
- Inclui dependências: `python3`, `py3-pip`, `gcc`, `python3-dev`, `musl-dev`, `curl`

### Debian/Ubuntu
- Instala via `apt-get`
- Inclui dependências: `python3`, `python3-pip`, `build-essential`, `curl`

## 📊 Verificação da Instalação

Após a instalação, você pode verificar se tudo está funcionando:

```bash
# Verificação completa
sudo bash check.sh

# Verificação rápida
sudo bash install.sh -c
```

### O que é verificado:
- ✅ Presença do FFmpeg
- ✅ Versão instalada
- ✅ Codecs disponíveis
- ✅ Teste de codificação
- ✅ Dependências necessárias
- ✅ Espaço em disco
- ✅ Logs do container

## 🐛 Solução de Problemas

### Container não encontrado
```bash
# Verifique se o n8n está rodando
docker ps | grep n8n

# Se estiver usando nome diferente, modifique o script ou use:
docker ps --format "{{.Names}}" | grep <seu-padrao>
```

### Erro de permissão
```bash
# Certifique-se de executar como root
sudo bash install.sh
```

### Falha na instalação
```bash
# Verifique os logs
sudo bash check.sh

# Tente reinstalar
sudo bash install.sh -u
sudo bash install.sh -y
```

### Problemas de conectividade
```bash
# Verifique se o container tem acesso à internet
docker exec <container-id> ping -c 3 google.com
```

## 📝 Logs e Debug

### Ver logs do container
```bash
docker logs <container-name>
```

### Executar comando manual no container
```bash
docker exec -it <container-name> sh
```

### Verificar FFmpeg manualmente
```bash
docker exec <container-name> ffmpeg -version
```

## 🔄 Atualizações

Para atualizar o FFmpeg:

```bash
# Desinstalar versão atual
sudo bash install.sh -u

# Instalar nova versão
sudo bash install.sh -y
```

## 📁 Estrutura do Projeto

```
n8n-ffmpeg-mago/
├── install.sh          # Script principal de instalação
├── check.sh            # Script de verificação
├── README.md           # Esta documentação
└── .github/
    └── workflows/
        ├── install.sh  # Script original (legado)
        └── README.md   # Documentação original
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🆘 Suporte

Se você encontrar problemas:

1. Execute `sudo bash check.sh` para diagnóstico
2. Verifique os logs do container
3. Abra uma issue no GitHub com:
   - Output do comando check.sh
   - Logs do container
   - Descrição do problema

## 🎯 Próximos Passos

- [ ] Suporte a mais distribuições Linux
- [ ] Instalação via Dockerfile personalizado
- [ ] Integração com CI/CD
- [ ] Monitoramento automático de atualizações
- [ ] Interface web para gerenciamento

---

**Desenvolvido com ❤️ para a comunidade n8n**
