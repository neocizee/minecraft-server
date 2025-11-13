# Usamos una imagen base estable de Debian
FROM debian:stable

# CRÍTICO: Paso 1. Instalar herramientas necesarias y limpiar listas
# Este paso instala curl y gnupg2 de forma segura.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    coreutils && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: Paso 2. Configurar el repositorio de PlayIt.gg
# Usamos 'install -m' para asegurar la creación y permisos correctos del archivo de keyring.
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | install -m 644 /dev/stdin /usr/share/keyrings/playit-cloud.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/playit-cloud.gpg] https://playit-cloud.github.io/ppa/data ./" > /etc/apt/sources.list.d/playit-cloud.list

# CRÍTICO: Paso 3. Instalar el agente de PlayIt y limpiar
# Este paso finaliza la instalación.
RUN apt-get update && \
    apt-get install -y playit && \
    rm -rf /var/lib/apt/lists/*

# CRÍTICO: El ENTRYPOINT fuerza la impresión inmediata de logs (para ver el código de claim)
ENTRYPOINT ["stdbuf", "-o", "L", "/usr/bin/playit"]
