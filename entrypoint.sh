#!/bin/sh

PERSISTENT_DIR="/data"
SERVER_JAR="/server/paper.jar"
PERSISTENT_JAR="${PERSISTENT_DIR}/paper.jar"

# 1. Copia el JAR del contenedor al volumen SÓLO si no existe
if [ ! -f "$PERSISTENT_JAR" ]; then
    echo "Inicializando volumen. Copiando paper.jar y archivos iniciales a ${PERSISTENT_DIR}..."
    cp "$SERVER_JAR" "$PERSISTENT_DIR"/
    cp /server/server.properties "$PERSISTENT_DIR"/
    cp /server/eula.txt "$PERSISTENT_DIR"/
    cp -r /server/plugins "$PERSISTENT_DIR"/
fi

# 2. Ejecuta el servidor usando el JAR del volumen (persistencia)
# Usa el JAR del volumen para que se persistan los cambios.
exec java $JAVA_OPTS $JAVA_OPTS_GC -jar "$PERSISTENT_JAR" nogui