#!/bin/bash

# Directorio en el volumen donde viven los archivos (definido en docker-compose)
PERSISTENT_DIR="/data"
# Directorio donde están los archivos dentro de la imagen (definido en Dockerfile)
IMAGE_DIR="/server"
SERVER_JAR="${IMAGE_DIR}/paper.jar"
PERSISTENT_JAR="${PERSISTENT_DIR}/paper.jar"

echo "Iniciando proceso de validación y arranque."

# CRÍTICO: Copiar el JAR del contenedor al volumen en CADA INICIO.
# Esto garantiza que siempre se use la última versión de Paper después de un build.
cp -f "$SERVER_JAR" "$PERSISTENT_JAR"
echo "paper.jar copiado/reemplazado en el volumen persistente (/data)."

# Copia de archivos de configuración iniciales SÓLO si el mundo no existe
# Si /data/world existe, el servidor ya fue inicializado
if [ ! -d "${PERSISTENT_DIR}/world" ]; then
    echo "Archivos iniciales (eula, server.properties, plugins) copiados a /data."
    
    # Copia inicial de la configuración y plugins
    cp "${IMAGE_DIR}/server.properties" "${PERSISTENT_DIR}/"
    cp "${IMAGE_DIR}/eula.txt" "${PERSISTENT_DIR}/"
    cp -r "${IMAGE_DIR}/plugins" "${PERSISTENT_DIR}/"
fi

# El 'exec' reemplaza el proceso de shell actual con el servidor Java.
# Esto asegura que Java sea el proceso principal (PID 1), crucial para Docker.
exec java $JAVA_OPTS $JAVA_OPTS_GC -jar "$PERSISTENT_JAR" nogui
