# Usamos una imagen base estable de Debian
FROM debian:stable

# Instalación atómica: Actualiza e instala todas las dependencias y playit.gg en un solo comando
# El uso de && \ garantiza que si falla un paso, todo el RUN falle inmediatamente.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    coreutils && \
    curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list && \
    apt-get update && \
    apt-get install -y playit && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: El ENTRYPOINT fuerza la impresión inmediata de logs
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
