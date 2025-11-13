# ETAPA 1: BUILDER (Descarga el JAR y configura archivos)
FROM eclipse-temurin:17-jre-alpine AS builder

# Instalar CURL y CA-CERTIFICATES
RUN apk update && \
    apk add --no-cache curl ca-certificates && \
    rm -rf /var/cache/apk/*

WORKDIR /tmp/build

# CRÍTICO: VARIABLE CACHE BUSTER
# Este argumento se pasa desde docker-compose.yml y debe cambiar en cada intento fallido.
ARG CACHE_BUST
RUN echo "Cache Buster Key: ${CACHE_BUST}"

# CRÍTICO: Descarga de PaperMC Build 196. Esta línea se ejecutará cada vez que CACHE_BUST cambie.
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/196/downloads/paper-1.20.1-196.jar"

# Configuración básica
RUN echo "eula=true" > eula.txt

# --- Lógica de Entorno (Se mantiene) ---
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /tmp/build/server.properties
RUN mkdir -p /tmp/build/plugins
COPY plugins /tmp/build/plugins

RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /tmp/build/plugins; \
    fi

# ETAPA 2: FINAL (Imagen de ejecución mínima de producción)
FROM eclipse-temurin:17-jre-alpine

WORKDIR /server

# Copiar solo el JAR y configs a la raíz de la imagen
COPY --from=builder /tmp/build/paper.jar /server/paper.jar
COPY --from=builder /tmp/build/server.properties /server/server.properties
COPY --from=builder /tmp/build/eula.txt /server/eula.txt
COPY --from=builder /tmp/build/plugins /server/plugins

# CRÍTICO: Script de inicio para manejar el volumen
# Si el paper.jar NO existe en el volumen, lo copia del contenedor.
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 25565

# CMD base
CMD java $JAVA_OPTS $JAVA_OPTS_GC -jar paper.jar nogui
