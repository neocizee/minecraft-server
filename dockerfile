# Base estable y ligera (Alpine con Java 17)
FROM eclipse-temurin:17-jre-alpine

# CRÍTICO: Instalar CURL y CA-CERTIFICATES
RUN apk update && \
    apk add --no-cache curl ca-certificates && \
    rm -rf /var/cache/apk/*

# CRÍTICO: Se fija un build específico para estabilidad (ej: el build 299)
ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="299" 
# NOTA: Debes verificar el build más reciente y estable en el sitio de PaperMC.

WORKDIR /server

# CRÍTICO: Usar la URL con las variables ARG fijas
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
