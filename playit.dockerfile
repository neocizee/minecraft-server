
# Imagen base Alpine (ligera y estable)
FROM alpine:3.19

# Instalar dependencias mínimas
RUN apk add --no-cache curl ca-certificates

# Descargar binario oficial desde GitHub releases (versión verificada)
RUN curl -SL https://github.com/playit-cloud/playit-agent/releases/download/v0.16.0/playit-linux-amd64 \
    -o /usr/local/bin/playit && \
    chmod +x /usr/local/bin/playit

# Directorio de trabajo donde se guardará la configuración
WORKDIR /etc/playit

# Ejecutar el agente directamente
ENTRYPOINT ["/usr/local/bin/playit"]
