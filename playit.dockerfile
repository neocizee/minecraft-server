# Usamos una imagen base mínima y estable de Debian (ideal para APT)
FROM debian:stable-slim

# CRÍTICO: Instalación Atómica de PlayIt.gg (Sigue la recomendación oficial)
# Este comando instala curl, gnupg2 y luego el agente, todo en una sola capa.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    coreutils && \
    # 1. Añade la llave GPG
    curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null && \
    # 2. Añade el repositorio
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list && \
    # 3. Actualiza e instala playit
    apt-get update && \
    apt-get install -y playit && \
    # Limpieza
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Define el directorio de trabajo. El agente de playit.gg guarda su configuración 
# en ~/.playit, que para el usuario root (por defecto) es /root/.playit.
WORKDIR /root

# CRÍTICO: El ENTRYPOINT fuerza la impresión inmediata de logs (para ver el código de claim)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
