# Usamos una imagen base mínima con las herramientas necesarias.
# Alpine es ideal: pequeña y estable.
FROM alpine:3.18

# Instalar CURL para descargar el binario
RUN apk update && \
    apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

# CRÍTICO: Descarga el binario estático de PlayIt.gg para Linux x86_64 directamente.
# Esto evita por completo el gestor de paquetes APT y los repositorios inestables.
RUN curl -fL -o /usr/bin/playit https://playit.cloud/api/v1/agent/downloads/playit-linux-x86_64 && \
    chmod +x /usr/bin/playit

# CRÍTICO: El ENTRYPOINT fuerza la impresión inmediata de logs (para ver el código de claim)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
