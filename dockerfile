FROM alpine:3.18 

# 'apk' es el gestor de paquetes. Instalamos java, curl y ca-certificates.
RUN apk update && \
    apk add --no-cache openjdk17-jre \
                       curl \
                       ca-certificates && \
    rm -rf /var/cache/apk/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

# Directorio de trabajo
WORKDIR /server

RUN curl -L -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"
RUN echo "eula=true" > eula.txt

EXPOSE 25565

# --- Lógica de Diferenciación por Entorno ---
ARG SERVER_ENV

# Copia el server.properties específico
COPY server.properties.${SERVER_ENV} /server/server.properties

# Copia los plugins comunes de forma segura
RUN mkdir -p /server/plugins
COPY plugins /server/plugins

# Copia plugins de Staging SOLO si estamos en Staging
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi

# Comando final de ejecución. Usamos la variable de entorno JAVA_OPTS para la RAM.
CMD ["java", "$JAVA_OPTS", "-jar", "paper.jar", "nogui"]
