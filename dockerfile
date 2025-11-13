
FROM alpine:3.18 


# 'apk' es el gestor de paquetes de Alpine.
RUN apk update && \
    apk add --no-cache openjdk17-jre \
                       curl \
                       ca-certificates && \
    rm -rf /var/cache/apk/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

RUN curl -L -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"
RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Entorno (Sin Cambios) ---
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
