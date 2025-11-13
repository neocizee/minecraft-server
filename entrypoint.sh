#!/bin/sh

PERSISTENT_DIR="/data"
SERVER_JAR="/server/paper.jar"
PERSISTENT_JAR="${PERSISTENT_DIR}/paper.jar"

echo "Iniciando proceso de validación y arranque."

# CRÍTICO: Copiar paper.jar del contenedor (imagen) al volumen (data) EN CADA INICIO.
# Esto asegura que la versión del JAR sea siempre la última de la imagen,
# pero solo si ha habido un build reciente (usando el Cache Buster).
# Esto sobreescribe cualquier JAR corrupto anterior en el volumen.
cp -f "$SERVER_JAR" "$PERSISTENT_JAR"
echo "paper.jar copiado/reemplazado en el volumen persistente (/data)."

# Copia de archivos de configuración iniciales SÓLO si no existe el mundo
# Los archivos como world/ deben seguir la lógica de "si no existe, copiar".
if [ ! -d "${PERSISTENT_DIR}/world" ]; then
    echo "Archivos iniciales (eula, server.properties) copiados a /data."
    cp /server/server.properties "$PERSISTENT_DIR"/
    cp /server/eula.txt "$PERSISTENT_DIR"/
    cp -r /server/plugins "$PERSISTENT_DIR"/
    # Si tienes carpetas como 'world', cópialas aquí si deben ser inicializadas
fi

# El 'exec' reemplaza el proceso de shell actual con el servidor Java.
# NOTA: Debes estar seguro de que los permisos de archivo sean correctos.
# Si sigue fallando, añade 'chown -R <user>:<group> /data' aquí.
exec java $JAVA_OPTS $JAVA_OPTS_GC -jar "$PERSISTENT_JAR" nogui
