# Usamos Ubuntu 22.04 LTS (Jammy), la base más compatible con el PPA.
FROM ubuntu:jammy 

# Paso 1: Instalar dependencias esenciales y limpiar.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    coreutils && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: Paso 2: Configurar el repositorio de PlayIt.gg de forma MANUAL y ATÓMICA.
# Este método es el más estable y evita el inestable comando 'add-apt-repository'.

# A. Descargar la llave GPG, convertirla a formato DEARMOR y guardarla directamente.
# Usamos un comando de tubería simple, guardando la salida en un archivo dedicado en el directorio de keyrings.
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor -o /usr/share/keyrings/playit-cloud.gpg

# B. Crear el archivo de lista de fuentes (.list) referenciando el nuevo archivo de llave GPG.
# Este archivo le dice a apt-get dónde encontrar los paquetes y cómo verificar su firma.
RUN echo "deb [signed-by=/usr/share/keyrings/playit-cloud.gpg] https://playit-cloud.github.io/ppa/data ./" > /etc/apt/sources.list.d/playit-cloud.list

# Paso 3: Instalar el agente de PlayIt.
# Hacemos un último update y luego instalamos.
RUN apt-get update && \
    apt-get install -y playit && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: ENTRYPOINT con fix de logs (stdbuf)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
