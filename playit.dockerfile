# Usamos Ubuntu 22.04 LTS (Jammy), la base natural para el PPA de PlayIt.gg.
FROM ubuntu:jammy 

# Paso 1: Instalar las dependencias (software-properties-common incluye 'add-apt-repository').
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: Paso 2: Agregar el repositorio de PlayIt.gg usando el comando nativo de Ubuntu.
# Este comando es mucho más estable para gestionar la llave GPG y el repo.
RUN add-apt-repository -y ppa:playit/playit

# Paso 3: Instalar el agente de PlayIt.
RUN apt-get update && \
    apt-get install -y playit && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: El ENTRYPOINT usa stdbuf para forzar la impresión inmediata de logs (fix de claim code)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
