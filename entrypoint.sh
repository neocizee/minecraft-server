#!/bin/bash

# Directorio en el volumen (donde reside el mundo)
PERSISTENT_DIR="/data"
# Directorio dentro de la imagen (donde están los archivos de la build)
IMAGE_DIR="/server"

echo "Iniciando proceso de validación y arranque."

# CRÍTICO: Copiar paper.jar del contenedor (imagen) al volumen (data) EN CADA INICIO.
# Esto asegura que la versión del JAR sea siempre la última después de un build, sobreescribiendo
# cualquier JAR corrupto o viejo en el volumen.
cp -f "${IMAGE_DIR}/paper.jar" "${PERSISTENT_DIR}/paper.jar"
echo "paper.jar copiado/reemplazado en el volumen persistente (${PERSISTENT_DIR})."

# Copia de archivos de configuración iniciales SÓLO si el mundo no existe.
# Esto es para evitar sobreescribir configuraciones que los usuarios pueden cambiar.
if [ ! -d "${PERSISTENT_DIR}/world" ]; then
    echo "Archivos iniciales (eula.txt, server.properties, plugins) copiados a /data."
    
    # Copia inicial de la configuración y plugins (usamos -r para plugins)
    cp "${IMAGE_DIR}/server.properties" "${PERSISTENT_DIR}/"
    cp "${IMAGE_DIR}/eula.txt" "${PERSISTENT_DIR}/"
    cp -r "${IMAGE_DIR}/plugins" "${PERSISTENT_DIR}/"
fi

# El 'exec' ejecuta el servidor Java como PID 1 (Buena práctica DevOps)
# Ejecuta el JAR desde el volumen persistente (${PERSISTENT_DIR}/paper.jar)
exec java $JAVA_OPTS $JAVA_OPTS_GC -jar "${PERSISTENT_DIR}/paper.jar" nogui