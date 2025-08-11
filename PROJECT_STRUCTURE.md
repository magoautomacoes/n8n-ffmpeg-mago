# 📁 Estrutura do Projeto n8n-ffmpeg-mago

## Visão Geral

Este documento descreve a estrutura completa do projeto **n8n-ffmpeg-mago**, um instalador automatizado de FFmpeg para containers n8n no Docker Swarm.

## 🗂️ Estrutura de Diretórios

```
n8n-ffmpeg-mago/
├── 📄 Scripts Principais
│   ├── install.sh              # Script principal de instalação
│   ├── check.sh                # Script de verificação completa
│   └── test.sh                 # Script de teste rápido
│
├── 📋 Documentação
│   ├── README.md               # Documentação principal
│   ├── QUICKSTART.md           # Guia de início rápido
│   ├── CHANGELOG.md            # Histórico de versões
│   ├── CONTRIBUTING.md         # Guia de contribuição
│   ├── LICENSE                 # Licença MIT
│   └── PROJECT_STRUCTURE.md    # Este arquivo
│
├── ⚙️ Configuração
│   ├── config.json             # Configurações do projeto
│   └── .gitignore              # Arquivos ignorados pelo Git
│
├── 📚 Documentação Detalhada
│   └── docs/
│       └── ffmpeg-usage-guide.md  # Guia de uso do FFmpeg
│
├── 🔧 Exemplos
│   └── examples/
│       └── ffmpeg-workflow-example.json  # Workflow n8n de exemplo
│
├── 🐙 GitHub
│   └── .github/
│       ├── ISSUE_TEMPLATE/     # Templates para issues
│       │   ├── bug_report.md
│       │   └── feature_request.md
│       ├── workflows/          # Scripts originais (legado)
│       │   ├── install.sh
│       │   └── README.md
│       ├── FUNDING.yml         # Configuração de financiamento
│       └── pull_request_template.md  # Template para PRs
│
└── 📦 Arquivos do Sistema
    └── .git/                   # Controle de versão Git
```

## 📄 Descrição dos Arquivos

### Scripts Principais

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| `install.sh` | Script principal de instalação do FFmpeg | 9.3KB |
| `check.sh` | Script de verificação e diagnóstico completo | 7.9KB |
| `test.sh` | Script de teste rápido do ambiente | 2.9KB |

### Documentação

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| `README.md` | Documentação principal do projeto | 5.5KB |
| `QUICKSTART.md` | Guia de início rápido | 1.3KB |
| `CHANGELOG.md` | Histórico de versões | 1.7KB |
| `CONTRIBUTING.md` | Guia de contribuição | 5.4KB |
| `LICENSE` | Licença MIT | 1.1KB |

### Configuração

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| `config.json` | Configurações centralizadas do projeto | 1.8KB |
| `.gitignore` | Arquivos ignorados pelo Git | 706B |

### GitHub Templates

| Arquivo | Descrição | Tamanho |
|---------|-----------|---------|
| `bug_report.md` | Template para reportar bugs | 947B |
| `feature_request.md` | Template para solicitar funcionalidades | 727B |
| `pull_request_template.md` | Template para pull requests | 1.4KB |
| `FUNDING.yml` | Configuração de financiamento | 740B |

## 🎯 Funcionalidades por Arquivo

### Scripts de Instalação

- **`install.sh`**: 
  - Detecção automática de sistema operacional
  - Instalação de dependências
  - Múltiplas opções de execução
  - Interface amigável com cores

- **`check.sh`**:
  - Verificação completa do sistema
  - Diagnóstico de problemas
  - Informações detalhadas do container
  - Testes de funcionalidade

- **`test.sh`**:
  - Verificação rápida do ambiente
  - Validação de pré-requisitos
  - Teste de conectividade

### Documentação

- **`README.md`**: Documentação completa com exemplos
- **`QUICKSTART.md`**: Guia de instalação em 3 passos
- **`docs/ffmpeg-usage-guide.md`**: Guia detalhado de uso do FFmpeg
- **`examples/ffmpeg-workflow-example.json`**: Workflow n8n de exemplo

### Configuração

- **`config.json`**: Configurações centralizadas
- **`.gitignore`**: Exclusão de arquivos desnecessários
- **`LICENSE`**: Licença MIT para uso livre

## 🔄 Fluxo de Desenvolvimento

### Para Usuários
1. Clone o repositório
2. Execute `bash test.sh`
3. Execute `sudo bash install.sh`
4. Use `sudo bash check.sh` para verificar

### Para Desenvolvedores
1. Fork o repositório
2. Crie uma branch para sua feature
3. Faça as mudanças
4. Teste com os scripts
5. Abra um Pull Request

## 📊 Estatísticas do Projeto

- **Total de arquivos**: 15
- **Total de linhas de código**: ~2,000+
- **Scripts principais**: 3
- **Documentação**: 6 arquivos
- **Templates GitHub**: 4 arquivos
- **Exemplos**: 1 workflow

## 🎨 Convenções

### Nomenclatura
- Scripts: `nome_acao.sh`
- Documentação: `NOME_DESCRITIVO.md`
- Configuração: `config.json`
- Templates: `tipo_template.md`

### Estrutura de Commits
- `feat:` novas funcionalidades
- `fix:` correções de bugs
- `docs:` mudanças na documentação
- `style:` formatação
- `refactor:` refatoração

## 🚀 Próximos Passos

1. **Testar em diferentes ambientes**
2. **Adicionar mais exemplos de workflows**
3. **Implementar CI/CD**
4. **Criar interface web**
5. **Adicionar suporte a mais distribuições**

---

**📝 Nota**: Esta estrutura foi projetada para ser escalável, manutenível e fácil de usar tanto para usuários finais quanto para contribuidores.
