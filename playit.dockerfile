# Usamos Alpine. Es rápido y estable.
FROM alpine:3.18

# Instala solo las herramientas necesarias (curl para el script de descarga)
RUN apk update && \
    apk add --no-cache curl coreutils && \
    rm -rf /var/cache/apk/*

# Copia el script de entrada que descargará y ejecutará el binario
COPY playit-entrypoint.sh /usr/local/bin/playit-entrypoint.sh
RUN chmod +x /usr/local/bin/playit-entrypoint.sh

# Directorio de trabajo: Aquí se mapeará el volumen playit_config_data
WORKDIR /app

# El entrypoint se encargará de todo
ENTRYPOINT ["/usr/local/bin/playit-entrypoint.sh"]