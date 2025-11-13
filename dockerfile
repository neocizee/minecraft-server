# ETAPA 1: BUILDER (Descarga el JAR y configura archivos)
FROM eclipse-temurin:17-jre-alpine AS builder

# Instalar CURL y CA-CERTIFICATES (Necesario en Alpine para HTTPS)
RUN apk update && \
    apk add --no-cache curl ca-certificates && \
    rm -rf /var/cache/apk/*

WORKDIR /server

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
COPY server.properties.${SERVER_ENV} /server/server.properties
RUN mkdir -p /server/plugins
COPY plugins /server/plugins

RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# ETAPA 2: FINAL (Imagen de ejecución mínima de producción)
FROM eclipse-temurin:17-jre-alpine

WORKDIR /server

# Copiar solo los artefactos necesarios de la etapa builder
COPY --from=builder /server/paper.jar /server/paper.jar
COPY --from=builder /server/server.properties /server/server.properties
COPY --from=builder /server/eula.txt /server/eula.txt
COPY --from=builder /server/plugins /server/plugins

EXPOSE 25565

# CMD base
CMD java $JAVA_OPTS $JAVA_OPTS_GC -jar paper.jar nogui
