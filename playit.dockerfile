# Usamos una imagen base estable de Debian
FROM debian:stable

# Instalación atómica: Actualiza e instala todas las dependencias y playit.gg en un solo comando
# El uso de 'apt-get install -y' y la limpieza en el mismo RUN mejora la fiabilidad.
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

# CRÍTICO: El ENTRYPOINT fuerza la impresión inmediata de logs (incluido el código de claim)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
