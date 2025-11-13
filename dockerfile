# ETAPA 1: BUILDER
FROM eclipse-temurin:17-jre-alpine AS builder
RUN apk update && apk add --no-cache curl ca-certificates bash && rm -rf /var/cache/apk/*
WORKDIR /server
RUN curl -fL -o paper.jar "https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/196/downloads/paper-1.20.1-196.jar"
RUN echo "eula=true" > eula.txt
ARG SERVER_ENV
COPY server.properties.${SERVER_ENV} /server/server.properties
RUN mkdir -p /server/plugins
COPY plugins /server/plugins
RUN if [ "$SERVER_ENV" = "staging" ]; then cp -r plugins.staging/. /server/plugins; fi
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# ETAPA 2: FINAL
FROM eclipse-temurin:17-jre-alpine
WORKDIR /server
COPY --from=builder /server /server
COPY --from=builder /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 25565
CMD ["/usr/local/bin/entrypoint.sh"]
