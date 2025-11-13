# playit.dockerfile
# Usamos Alpine: pequeña, rápida y estable.
FROM alpine:3.18

# 1. Instala CURL y la utilidad stdbuf (para forzar logs)
RUN apk update && \
    apk add --no-cache curl coreutils && \
    rm -rf /var/cache/apk/*

# 2. CRÍTICO: Descarga el binario playit.gg en el BUILD TIME
# Esto soluciona de forma definitiva el error "Could not resolve host"
RUN curl -fL -o /usr/local/bin/playit-agent https://playit.cloud/api/v1/agent/downloads/playit-linux-x86_64 && \
    chmod +x /usr/local/bin/playit-agent

# 3. Define un WORKDIR
# /app es donde el volumen persistente mapeará, y PlayIt guarda su configuración
WORKDIR /app

# 4. El ENTRYPOINT directamente lanza el binario. stdbuf -o L fuerza el streaming de logs.
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/local/bin/playit-agent"]