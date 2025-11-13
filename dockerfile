# ETAPA 1: BUILDER (Descarga el JAR y configura archivos)
FROM eclipse-temurin:17-jre-alpine AS builder

# Instalar CURL y CA-CERTIFICATES (Necesario en Alpine para HTTPS)
# Se incluye el script de inicio
RUN apk update && \
    apk add --no-cache curl ca-certificates bash && \
    rm -rf /var/cache/apk/*

WORKDIR /tmp/build

# Usar URL FIJA para estabilidad (Paper 1.20.1 build 196)
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/196/downloads/paper-1.20.1-196.jar"

# Configuración básica (se copiarán al volumen por el entrypoint.sh)
RUN echo "eula=true" > eula.txt

# --- Lógica de Entorno (Se mantiene) ---
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /tmp/build/server.properties
RUN mkdir -p /tmp/build/plugins
COPY plugins /tmp/build/plugins

RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /tmp/build/plugins; \
    fi
    
# Copiar el entrypoint script para que sea accesible
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


# ETAPA 2: FINAL (Imagen de ejecución mínima de producción)
FROM eclipse-temurin:17-jre-alpine

WORKDIR /server

# Copiar solo los artefactos necesarios
COPY --from=builder /tmp/build/paper.jar /server/paper.jar
COPY --from=builder /tmp/build/server.properties /server/server.properties
COPY --from=builder /tmp/build/eula.txt /server/eula.txt
COPY --from=builder /tmp/build/plugins /server/plugins
COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh

# El WORKDIR /server es de donde el entrypoint.sh copia los archivos
EXPOSE 25565

# CMD final es el comando de la ejecución (el entrypoint.sh)
CMD ["/usr/local/bin/entrypoint.sh"]
