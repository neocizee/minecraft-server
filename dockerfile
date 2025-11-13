FROM alpine:3.18 

RUN apk update && \
    apk add --no-cache openjdk17-jre \
                       curl \
                       ca-certificates && \
    rm -rf /var/cache/apk/*

ARG MINECRAFT_VERSION="1.20.1"
ARG PAPER_BUILD="latest"

WORKDIR /server

# SOLUCIÓN DESCARGA: Usar curl (-L para redirecciones) en lugar de wget.
RUN curl -L -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${PAPER_BUILD}/downloads/paper-${MINECRAFT_VERSION}-${PAPER_BUILD}.jar"
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

# SOLUCIÓN RAM: Incluir la variable $JAVA_OPTS para pasar la configuración de RAM desde docker-compose.
CMD ["java", "$JAVA_OPTS", "-jar", "paper.jar", "nogui"]
