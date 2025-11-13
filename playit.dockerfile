# Usamos una imagen base estable de Debian
FROM debian:stable

# Instalar dependencias necesarias y el cliente playit
# Añadimos 'coreutils' para usar 'stdbuf'
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl gnupg2 coreutils && \
    rm -rf /var/lib/apt/lists/*

# 1. Añade la llave GPG
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null

# 2. Añade el repositorio
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list

# 3. Actualiza e instala playit
RUN apt-get update && apt-get install -y playit

# CRÍTICO: Usamos ENTRYPOINT con stdbuf -o L
# Esto fuerza la impresión inmediata del output (como el código de claim) en los logs de Docker.
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
