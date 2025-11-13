#!/bin/bash
set -e

PERSISTENT_DIR="/data"
IMAGE_DIR="/server"

echo "Iniciando proceso de validación y arranque."

# CRÍTICO: Copia/Reemplaza el paper.jar del contenedor al volumen en CADA INICIO (para actualizaciones)
# Esto asegura que si reconstruyes la imagen con una nueva versión de Paper, se use el nuevo JAR.
cp -f "${IMAGE_DIR}/paper.jar" "${PERSISTENT_DIR}/paper.jar"
echo "paper.jar copiado/reemplazado en el volumen persistente (/data)."

# Copia de archivos de configuración iniciales SÓLO si el mundo no existe
# Esto evita sobrescribir server.properties, eula.txt o plugins personalizados.
if [ ! -d "${PERSISTENT_DIR}/world" ]; then
    echo "Archivos iniciales (eula.txt, server.properties, plugins) copiados a /data."
    cp "${IMAGE_DIR}/server.properties" "${PERSISTENT_DIR}/"
    cp "${IMAGE_DIR}/eula.txt" "${PERSISTENT_DIR}/"
    cp -r "${IMAGE_DIR}/plugins" "${PERSISTENT_DIR}/"
fi

# Ejecuta el servidor Java como PID 1
exec java $JAVA_OPTS $JAVA_OPTS_GC -jar "${PERSISTENT_DIR}/paper.jar" nogui