# 1. CRÍTICO: Usar la imagen base Alpine con Java. Es ligera y minimiza fallos de build.
FROM eclipse-temurin:17-jre-alpine

# 2. Instalar wget con el gestor de paquetes de Alpine (apk).
RUN apk update && \
    apk add --no-cache wget && \
    rm -rf /var/cache/apk/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

# 3. Descarga estable: Comando simple. (Si la red es estable, esto funciona).
RUN wget -O paper.jar https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar
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

# El CMD base será sobrescrito por 'command:' en docker-compose
CMD ["java", "-jar", "paper.jar", "nogui"]