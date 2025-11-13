# 1. Usar una imagen base estable y completa de Java 17 JRE (Eclipse Temurin)
FROM eclipse-temurin:17-jre-focal

# Instalar wget (necesario en esta imagen base)
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

# 2. CRÍTICO: Usar wget con 5 reintentos (--tries=5) para asegurar una descarga completa.
RUN wget --tries=5 -O paper.jar https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar
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

# El CMD base será sobrescrito por docker-compose.
CMD ["java", "-jar", "paper.jar", "nogui"]
