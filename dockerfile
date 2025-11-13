# Base estable y ligera (Alpine con Java 17)
FROM eclipse-temurin:17-jre-alpine

# CRÍTICO: Instalar CURL y CA-CERTIFICATES para asegurar la descarga HTTPS
# La falta de ca-certificates es la causa más común de fallos de red/protocolo (exit code 8) en entornos Alpine.
RUN apk update && \
    apk add --no-cache curl ca-certificates && \
    rm -rf /var/cache/apk/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

# CRÍTICO: Usar solo curl -fL. La lógica de fallback falló.
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"

RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Entorno (Se mantiene) ---
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /server/server.properties
RUN mkdir -p /server/plugins
COPY plugins /server/plugins
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# CMD base (Sobreescrito por docker-compose para RAM)
CMD ["java", "-jar", "paper.jar", "nogui"]
