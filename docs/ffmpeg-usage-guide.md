# 🎬 Guia de Uso do FFmpeg no n8n

Este guia mostra como usar o FFmpeg instalado no seu container n8n para processamento de vídeo e áudio.

## 📋 Pré-requisitos

- FFmpeg instalado via `install.sh`
- Container n8n em execução
- Acesso ao n8n via interface web

## 🔧 Configuração Básica

### 1. Verificar Instalação

Primeiro, verifique se o FFmpeg está instalado corretamente:

```bash
sudo bash check.sh
```

### 2. Testar FFmpeg no Container

Execute um teste básico:

```bash
# Encontrar o container n8n
docker ps | grep n8n

# Testar FFmpeg
docker exec <container-name> ffmpeg -version
```

## 🎯 Casos de Uso Comuns

### 1. Conversão de Formato de Vídeo

**Comando FFmpeg:**
```bash
ffmpeg -i input.mp4 -c:v libx264 -c:a aac output.mp4
```

**No n8n (Execute Command Node):**
```bash
ffmpeg -i {{ $json.inputFile }} -c:v libx264 -c:a aac {{ $json.outputFile }} -y
```

### 2. Redimensionamento de Vídeo

**Comando FFmpeg:**
```bash
ffmpeg -i input.mp4 -vf scale=1280:720 output.mp4
```

**No n8n:**
```bash
ffmpeg -i {{ $json.inputFile }} -vf scale={{ $json.width }}:{{ $json.height }} {{ $json.outputFile }} -y
```

### 3. Extração de Áudio

**Comando FFmpeg:**
```bash
ffmpeg -i video.mp4 -vn -acodec mp3 audio.mp3
```

**No n8n:**
```bash
ffmpeg -i {{ $json.videoFile }} -vn -acodec mp3 {{ $json.audioFile }} -y
```

### 4. Criação de Thumbnail

**Comando FFmpeg:**
```bash
ffmpeg -i video.mp4 -ss 00:00:10 -vframes 1 thumbnail.jpg
```

**No n8n:**
```bash
ffmpeg -i {{ $json.videoFile }} -ss {{ $json.timestamp }} -vframes 1 {{ $json.thumbnailFile }} -y
```

## 🔄 Workflows Exemplos

### Workflow 1: Conversão Automática de Vídeos

```javascript
// Node: Code (Prepare Data)
const inputData = $input.first().json;

// Configurações de conversão
const conversionSettings = {
  mp4: '-c:v libx264 -c:a aac -preset medium',
  webm: '-c:v libvpx-vp9 -c:a libopus -preset medium',
  avi: '-c:v libxvid -c:a mp3'
};

const format = inputData.format || 'mp4';
const options = conversionSettings[format];

return {
  inputFile: inputData.filePath,
  outputFile: inputData.filePath.replace(/\.[^/.]+$/, `.${format}`),
  ffmpegOptions: options
};
```

```bash
# Node: Execute Command
ffmpeg -i {{ $json.inputFile }} {{ $json.ffmpegOptions }} {{ $json.outputFile }} -y
```

### Workflow 2: Processamento em Lote

```javascript
// Node: Code (Batch Processing)
const files = $input.all();

return files.map(file => ({
  inputFile: file.json.filePath,
  outputFile: file.json.filePath.replace('.mp4', '_processed.mp4'),
  quality: 'medium'
}));
```

```bash
# Node: Execute Command (para cada item)
ffmpeg -i {{ $json.inputFile }} -crf 23 -preset medium {{ $json.outputFile }} -y
```

### Workflow 3: Monitoramento de Qualidade

```javascript
// Node: Code (Quality Check)
const ffmpegOutput = $input.first().json.stdout;

// Extrair informações do vídeo
const durationMatch = ffmpegOutput.match(/Duration: (\d{2}):(\d{2}):(\d{2})/);
const bitrateMatch = ffmpegOutput.match(/bitrate: (\d+) kb\/s/);

return {
  duration: durationMatch ? `${durationMatch[1]}:${durationMatch[2]}:${durationMatch[3]}` : 'unknown',
  bitrate: bitrateMatch ? `${bitrateMatch[1]} kb/s` : 'unknown',
  success: $input.first().json.exitCode === 0
};
```

## 🎨 Configurações Avançadas

### Qualidade de Vídeo

| Qualidade | CRF | Preset | Descrição |
|-----------|-----|--------|-----------|
| Baixa | 28 | fast | Arquivo pequeno, qualidade menor |
| Média | 23 | medium | Equilíbrio entre qualidade e tamanho |
| Alta | 18 | slow | Arquivo maior, qualidade superior |

### Codecs Recomendados

**Vídeo:**
- H.264 (libx264): Compatibilidade universal
- H.265 (libx265): Melhor compressão
- VP9 (libvpx-vp9): Web otimizado

**Áudio:**
- AAC: Padrão para MP4
- MP3: Compatibilidade máxima
- Opus: Melhor qualidade/tamanho

## 🔍 Monitoramento e Debug

### Verificar Progresso

```bash
# Adicionar barra de progresso
ffmpeg -i input.mp4 -progress pipe:1 -c:v libx264 output.mp4
```

### Logs Detalhados

```bash
# Logs verbosos
ffmpeg -v debug -i input.mp4 output.mp4
```

### Verificar Informações do Arquivo

```bash
# Informações detalhadas
ffprobe -v quiet -print_format json -show_format -show_streams input.mp4
```

## 🚀 Otimizações

### Performance

1. **Usar presets apropriados:**
   ```bash
   ffmpeg -i input.mp4 -preset ultrafast output.mp4  # Mais rápido
   ffmpeg -i input.mp4 -preset slow output.mp4       # Melhor qualidade
   ```

2. **Paralelização:**
   ```bash
   ffmpeg -i input.mp4 -threads 4 output.mp4
   ```

3. **Cache otimizado:**
   ```bash
   ffmpeg -i input.mp4 -c:v libx264 -tune fastdecode output.mp4
   ```

### Qualidade

1. **CRF (Constant Rate Factor):**
   ```bash
   ffmpeg -i input.mp4 -crf 18 output.mp4  # Qualidade muito alta
   ffmpeg -i input.mp4 -crf 28 output.mp4  # Qualidade baixa
   ```

2. **Two-pass encoding:**
   ```bash
   # Primeira passagem
   ffmpeg -i input.mp4 -c:v libx264 -b:v 2M -pass 1 -f null /dev/null
   # Segunda passagem
   ffmpeg -i input.mp4 -c:v libx264 -b:v 2M -pass 2 output.mp4
   ```

## 🐛 Solução de Problemas

### Erro: "ffmpeg: command not found"
```bash
# Verificar se FFmpeg está instalado
sudo bash check.sh

# Reinstalar se necessário
sudo bash install.sh -y
```

### Erro: "Permission denied"
```bash
# Verificar permissões do diretório
docker exec <container-name> ls -la /tmp

# Ajustar permissões se necessário
docker exec <container-name> chmod 755 /tmp
```

### Erro: "No space left on device"
```bash
# Verificar espaço em disco
sudo bash check.sh

# Limpar arquivos temporários
docker exec <container-name> rm -rf /tmp/*
```

### Erro: "Invalid data found when processing input"
```bash
# Verificar se o arquivo está corrompido
ffprobe input.mp4

# Tentar reparar
ffmpeg -i input.mp4 -c copy -fflags +genpts output.mp4
```

## 📊 Métricas e Monitoramento

### Tempo de Processamento

```javascript
// Node: Code (Performance Monitor)
const startTime = new Date();
const inputData = $input.first().json;

// Após processamento
const endTime = new Date();
const processingTime = endTime - startTime;

return {
  ...inputData,
  processingTime: processingTime.getTime(),
  processingTimeFormatted: `${processingTime.getSeconds()}s`
};
```

### Qualidade do Resultado

```bash
# Verificar qualidade do vídeo processado
ffprobe -v quiet -show_entries format=duration,size,bit_rate -of json output.mp4
```

## 🔗 Integração com Outros Serviços

### Upload para Cloud Storage

```javascript
// Node: Code (Prepare Upload)
const processedFile = $input.first().json.outputFile;
const fileName = processedFile.split('/').pop();

return {
  filePath: processedFile,
  fileName: fileName,
  contentType: 'video/mp4',
  uploadUrl: 'https://api.cloudstorage.com/upload'
};
```

### Notificação de Conclusão

```javascript
// Node: Code (Notification)
const result = $input.first().json;

return {
  message: `Processamento concluído: ${result.fileName}`,
  status: result.success ? 'success' : 'error',
  processingTime: result.processingTime,
  fileSize: result.fileSize
};
```

## 📚 Recursos Adicionais

- [Documentação oficial do FFmpeg](https://ffmpeg.org/documentation.html)
- [FFmpeg Wiki](https://trac.ffmpeg.org/wiki)
- [Guia de codecs](https://trac.ffmpeg.org/wiki/Encode/H.264)
- [Exemplos de comandos](https://trac.ffmpeg.org/wiki/Examples)

---

**💡 Dica:** Sempre teste seus comandos FFmpeg em arquivos pequenos antes de processar arquivos grandes em produção.
