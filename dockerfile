# ETAPA 1: BUILDER (Descarga el JAR y configura archivos)
# Usamos una base estable con Java 17
FROM eclipse-temurin:17-jre-alpine AS builder

# Instalar CURL y CA-CERTIFICATES (Necesario en Alpine para HTTPS)
RUN apk update && \
    apk add --no-cache curl ca-certificates bash && \
    rm -rf /var/cache/apk/*

WORKDIR /server

# CRÍTICO: Usar URL FIJA para estabilidad (Paper 1.20.1 build 196)
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/196/downloads/paper-1.20.1-196.jar"

# Configuración básica inicial (copiada por el entrypoint.sh)
RUN echo "eula=true" > eula.txt

# --- Lógica de Entorno ---
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /server/server.properties
RUN mkdir -p /server/plugins
COPY plugins /server/plugins
RUN if [ "$SERVER_ENV" = "staging" ]; then \
      cp -r plugins.staging/. /server/plugins; \
    fi
    
# Copiar el script de entrada (entrypoint.sh)
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


# ETAPA 2: FINAL (Imagen de ejecución mínima de producción)
FROM eclipse-temurin:17-jre-alpine

# Copiar solo los artefactos necesarios
COPY --from=builder /server /server
COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /server
EXPOSE 25565

# CMD llama al entrypoint.sh (command: en docker-compose lo sobrescribe, pero se mantiene como buena práctica)
CMD ["/usr/local/bin/entrypoint.sh"]