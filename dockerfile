FROM openjdk:17-jre-slim

# CRÍTICO: Instalar 'curl' para una descarga segura y 'bash' para la lógica de scripts.
# openjdk:17-jre-slim está basado en Debian/Ubuntu, así que usamos 'apt'.
RUN apt update && \
    apt install -y curl bash && \
    rm -rf /var/lib/apt/lists/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

# Usuario por defecto y directorio de trabajo
WORKDIR /server

# Descarga del jar: Se usa 'curl' con redireccionamiento (-L) y salida (-o)
RUN curl -L -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"
RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Diferenciación por Entorno ---
ARG SERVER_ENV

# 1. Copia el server.properties específico
COPY server.properties.${SERVER_ENV} /server/server.properties

# 2. Copia los plugins comunes de forma segura
RUN mkdir -p /server/plugins
COPY plugins /server/plugins

# 3. Copia plugins de Staging SOLO si estamos en Staging (lógica condicional)
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# Comando final de ejecución.
CMD ["java", "-jar", "paper.jar", "nogui"]
