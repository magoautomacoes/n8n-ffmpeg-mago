# Contribuindo para o n8n-ffmpeg-mago

Obrigado por considerar contribuir para o projeto! Este documento fornece diretrizes para contribuições.

## 🚀 Como Contribuir

### 1. Fork e Clone

1. Faça um fork do repositório
2. Clone seu fork localmente:
   ```bash
   git clone https://github.com/seu-usuario/n8n-ffmpeg-mago.git
   cd n8n-ffmpeg-mago
   ```

### 2. Crie uma Branch

Crie uma branch para sua feature ou correção:
```bash
git checkout -b feature/nova-funcionalidade
# ou
git checkout -b fix/correcao-bug
```

### 3. Faça suas Mudanças

- Escreva código limpo e bem documentado
- Siga as convenções de nomenclatura existentes
- Adicione testes quando apropriado
- Atualize a documentação conforme necessário

### 4. Teste suas Mudanças

Antes de submeter, teste suas mudanças:
```bash
# Teste o script de instalação
sudo bash test.sh

# Teste a instalação (se aplicável)
sudo bash install.sh -y

# Teste a verificação
sudo bash check.sh
```

### 5. Commit e Push

Faça commits com mensagens descritivas:
```bash
git add .
git commit -m "feat: adiciona nova funcionalidade X"
git push origin feature/nova-funcionalidade
```

### 6. Abra um Pull Request

1. Vá para o repositório original no GitHub
2. Clique em "New Pull Request"
3. Selecione sua branch
4. Preencha o template do PR
5. Aguarde a revisão

## 📝 Padrões de Commit

Use o formato convencional de commits:

- `feat:` nova funcionalidade
- `fix:` correção de bug
- `docs:` mudanças na documentação
- `style:` formatação, ponto e vírgula, etc.
- `refactor:` refatoração de código
- `test:` adição ou correção de testes
- `chore:` mudanças em build, dependências, etc.

Exemplo:
```bash
git commit -m "feat: adiciona suporte para Ubuntu 22.04"
git commit -m "fix: corrige problema de permissão no Alpine"
git commit -m "docs: atualiza guia de instalação"
```

## 🔧 Desenvolvimento Local

### Pré-requisitos

- Docker instalado
- Acesso root (sudo)
- Conhecimento básico de shell scripting

### Estrutura do Projeto

```
n8n-ffmpeg-mago/
├── install.sh              # Script principal
├── check.sh                # Script de verificação
├── test.sh                 # Script de teste
├── config.json             # Configurações
├── README.md               # Documentação principal
├── QUICKSTART.md           # Guia rápido
├── CHANGELOG.md            # Histórico de versões
├── CONTRIBUTING.md         # Este arquivo
├── LICENSE                 # Licença
├── .gitignore              # Arquivos ignorados
├── docs/                   # Documentação detalhada
│   └── ffmpeg-usage-guide.md
└── examples/               # Exemplos
    └── ffmpeg-workflow-example.json
```

### Testando Mudanças

1. **Teste Básico:**
   ```bash
   bash test.sh
   ```

2. **Teste de Instalação:**
   ```bash
   sudo bash install.sh -y
   ```

3. **Teste de Verificação:**
   ```bash
   sudo bash check.sh
   ```

4. **Teste de Desinstalação:**
   ```bash
   sudo bash install.sh -u
   ```

## 🐛 Reportando Bugs

### Antes de Reportar

1. Verifique se o bug já foi reportado
2. Teste com a versão mais recente
3. Execute `sudo bash check.sh` para diagnóstico

### Template de Bug Report

```markdown
**Descrição do Bug**
Uma descrição clara e concisa do bug.

**Para Reproduzir**
1. Execute 'sudo bash install.sh'
2. Veja o erro...

**Comportamento Esperado**
O que deveria acontecer.

**Comportamento Atual**
O que realmente acontece.

**Informações do Sistema**
- Sistema Operacional: [ex: Ubuntu 20.04]
- Docker Version: [ex: 20.10.0]
- n8n Version: [ex: 0.200.0]

**Logs**
```
Output do comando: sudo bash check.sh
```

**Screenshots**
Se aplicável, adicione screenshots.

**Contexto Adicional**
Qualquer outra informação relevante.
```

## 💡 Sugerindo Funcionalidades

### Template de Feature Request

```markdown
**Problema/Necessidade**
Uma descrição clara do problema que a funcionalidade resolveria.

**Solução Proposta**
Uma descrição da funcionalidade desejada.

**Alternativas Consideradas**
Outras soluções que você considerou.

**Contexto Adicional**
Qualquer contexto adicional sobre a funcionalidade.
```

## 📋 Checklist para Pull Requests

Antes de submeter um PR, verifique:

- [ ] Código segue os padrões do projeto
- [ ] Testes passam localmente
- [ ] Documentação foi atualizada
- [ ] Changelog foi atualizado (se necessário)
- [ ] Commits seguem o padrão convencional
- [ ] PR tem uma descrição clara
- [ ] Não há conflitos de merge

## 🤝 Código de Conduta

### Nossos Padrões

- Seja respeitoso e inclusivo
- Use linguagem apropriada
- Aceite críticas construtivas
- Foque no que é melhor para a comunidade

### Nossas Responsabilidades

- Manter um ambiente acolhedor
- Clarificar padrões de comportamento
- Tomar ações corretivas quando necessário

## 📞 Suporte

Se você tiver dúvidas sobre como contribuir:

1. Verifique a documentação existente
2. Procure por issues similares
3. Abra uma issue para discussão

## 🎉 Agradecimentos

Obrigado por contribuir para tornar este projeto melhor para todos!

---

**Lembre-se:** Cada contribuição, por menor que seja, é valiosa para a comunidade! 🚀
