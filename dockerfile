# Usa la imagen base oficial de Java
FROM eclipse-temurin:17-jre-alpine

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

# Usuario por defecto y directorio de trabajo
WORKDIR /server

# Descarga del jar
RUN wget -O paper.jar https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar
RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Diferenciación por Entorno (usando ARG SERVER_ENV) ---
ARG SERVER_ENV

# 1. Copia el server.properties específico
# Esto requiere que el archivo server.properties.main exista en el repositorio.
COPY server.properties.${SERVER_ENV} /server/server.properties

# 2. Copia los plugins comunes de forma segura
# Se crea la carpeta 'plugins' si no existe, y luego se copian los archivos
RUN mkdir -p /server/plugins
COPY plugins /server/plugins

# 3. Copia plugins de Staging SOLO si estamos en Staging (lógica condicional)
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# Comando final de ejecución. Quitamos -Xmx/-Xms si lo definimos en docker-compose
CMD ["java", "-jar", "paper.jar", "nogui"]
