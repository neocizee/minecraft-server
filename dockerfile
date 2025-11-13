# Dockerfile

# Usa la imagen base oficial de Java
FROM eclipse-temurin:17-jre-alpine

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

RUN wget -O paper.jar https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar
RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Diferenciación por Entorno (usando ARG SERVER_ENV) ---
# Argumento para diferenciar el entorno (Pasado desde docker-compose o Portainer)
ARG SERVER_ENV

# Copia de configuraciones
# 1. Copia el server.properties específico
COPY server.properties.${SERVER_ENV} /server/server.properties

# 2. Copia los plugins comunes
COPY plugins /server/plugins

# 3. Copia plugins de Staging SOLO si estamos en Staging (comando en una sola línea)
# (Si plugins.staging no existe, este comando fallaría. Debes asegurar que la carpeta existe en Git).
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# Comando final de ejecución. Quitamos -Xmx/-Xms si lo definimos en docker-compose
CMD ["java", "-jar", "paper.jar", "nogui"]
