# Usamos Alpine. Es rápido y estable.
FROM alpine:3.18

# Instala solo las herramientas necesarias para el script de entrypoint.
# Esto se ejecuta en build-time, pero es una dependencia estable.
RUN apk update && \
    apk add --no-cache curl coreutils && \
    rm -rf /var/cache/apk/*

# Copia el nuevo script de entrada que descargará el binario
COPY playit-entrypoint.sh /usr/local/bin/playit-entrypoint.sh
RUN chmod +x /usr/local/bin/playit-entrypoint.sh

# Define un directorio de trabajo
WORKDIR /app

# El entrypoint se encargará de todo
ENTRYPOINT ["/usr/local/bin/playit-entrypoint.sh"]