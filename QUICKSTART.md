# 🚀 Início Rápido - FFmpeg para n8n

## ⚡ Instalação em 3 Passos

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd n8n-ffmpeg-mago
```

### 2. Execute o teste
```bash
bash test.sh
```

### 3. Instale o FFmpeg
```bash
sudo bash install.sh
```

## 🎯 Comandos Essenciais

| Comando | Descrição |
|---------|-----------|
| `sudo bash install.sh` | Instalação interativa |
| `sudo bash install.sh -y` | Instalação automática |
| `sudo bash check.sh` | Verificação completa |
| `sudo bash install.sh -c` | Verificar apenas FFmpeg |
| `sudo bash install.sh -u` | Desinstalar FFmpeg |

## 🔍 Verificação Rápida

Após a instalação, teste se o FFmpeg está funcionando:

```bash
# Encontrar o container n8n
docker ps | grep n8n

# Testar FFmpeg
docker exec <container-name> ffmpeg -version
```

## 📚 Próximos Passos

1. **Leia o README.md** para documentação completa
2. **Consulte docs/ffmpeg-usage-guide.md** para exemplos de uso
3. **Importe examples/ffmpeg-workflow-example.json** no n8n

## 🆘 Problemas?

- Execute `sudo bash check.sh` para diagnóstico
- Verifique se o Docker está rodando
- Certifique-se de ter permissões root

---

**💡 Dica:** O script detecta automaticamente se seu container usa Alpine ou Debian/Ubuntu!
