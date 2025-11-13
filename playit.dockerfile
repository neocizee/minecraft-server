# Usamos Ubuntu 22.04 LTS (Jammy), que es la base natural para el PPA de PlayIt.gg.
FROM ubuntu:jammy 

# Paso 1: Instalar dependencias necesarias.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    coreutils && \
    rm -rf /var/lib/apt/lists/*

# Paso 2: Configurar el repositorio de PlayIt.gg de forma robusta.
# La instalación de la llave GPG ahora usa 'install' directamente en el directorio de keyrings.
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /usr/share/keyrings/playit-cloud.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/playit-cloud.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list

# Paso 3: Instalar el agente de PlayIt.
# Forzamos un update aquí para asegurar que la nueva lista de paquetes se lea.
RUN apt-get update && \
    apt-get install -y playit && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: El ENTRYPOINT usa stdbuf para forzar la impresión inmediata de logs (claim code fix)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
