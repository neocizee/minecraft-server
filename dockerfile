# Base estable y ligera (Alpine con Java 17)
FROM eclipse-temurin:17-jre-alpine

# CRÍTICO: Instalar curl y wget. (Doble seguridad para la descarga)
RUN apk update && \
    apk add --no-cache curl wget && \
    rm -rf /var/cache/apk/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

# CRÍTICO: Descarga con curl -L (maneja redirecciones) y wget de fallback
# Intentamos descargar con curl, si falla, wget (aunque sabemos que puede fallar)
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar" || \
    wget -O paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"

RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Entorno ---
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /server/server.properties
RUN mkdir -p /server/plugins
COPY plugins /server/plugins
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# CMD base (Será anulado por docker-compose)
CMD ["java", "-jar", "paper.jar", "nogui"]