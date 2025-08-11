# Instalador de FFmpeg para n8n (Orion / Docker Swarm)

Instala o **FFmpeg** dentro do container do **n8n** gerenciado pelo Orion (Swarm).

- Detecta se o container é Alpine (apk) ou Debian/Ubuntu (apt-get).
- Em Alpine: alinha OpenSSL (`openssl/libssl3/libcrypto3`) antes do ffmpeg para evitar conflito.
- Em Debian/Ubuntu: instala ffmpeg via apt.

## Uso

```bash
sudo bash install.sh
