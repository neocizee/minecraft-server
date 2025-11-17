# ETAPA 1: BUILDER
# Usamos eclipse-temurin:17-jre-alpine (ligero y con Java 17)
#FROM eclipse-temurin:17-jre-alpine AS builder
# Version 21 de java para soportar versiones mas nuevas de minecraft
FROM eclipse-temurin:21-jre-alpine AS builder

# Instalar dependencias necesarias (curl para descargar, bash para el script)
RUN apk update && apk add --no-cache curl ca-certificates bash && rm -rf /var/cache/apk/*

# WORKDIR temporal para el build
WORKDIR /server

# Descarga el JAR de PaperMC
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.21.5/builds/114/downloads/paper-1.21.5-114.jar"

# Configuración inicial
RUN echo "eula=true" > eula.txt
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /server/server.properties
RUN mkdir -p /server/plugins
COPY plugins /server/plugins
RUN if [ "$SERVER_ENV" = "staging" ]; then cp -r plugins.staging/. /server/plugins; fi

# Copia el script de entrada y dale permisos de ejecución
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN addgroup -g 1000 minecraftserver1 && \
    adduser -u 1000 -G minecraftserver1 -s /bin/sh -D minecraftserver1

RUN chown -R minecraftserver1:minecraftserver1 /server /usr/local/bin/entrypoint.sh

# ETAPA 2: FINAL (Imagen de ejecución mínima de producción)
#FROM eclipse-temurin:17-jre-alpine
FROM eclipse-temurin:21-jre-alpine


# WORKDIR final (donde el script busca los archivos antes de copiarlos al volumen /data)
WORKDIR /server

USER minecraftserver1

# Copia solo los archivos necesarios de la etapa de build
COPY --from=builder /server /server
COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 25565
CMD ["/usr/local/bin/entrypoint.sh"]