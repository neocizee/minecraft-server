#!/bin/sh

PERSISTENT_DIR="/data"
IMAGE_DIR="/server"

echo "Iniciando proceso de validación y arranque."

# =========================================================================
# 1. Copia/Reemplaza Archivos que Queremos ACTUALIZAR en cada Deploy (desde el repo)
# =========================================================================

# - paper.jar siempre se actualiza con el último del contenedor
cp -f "${IMAGE_DIR}/paper.jar" "${PERSISTENT_DIR}/paper.jar"
echo "paper.jar copiado/reemplazado en el volumen persistente (/data)."

# - server.properties, eula.txt, plugins iniciales (Si queremos que los cambios del repo sobreescriban)
# Si quieres que el usuario edite server.properties y que NO se sobreescriba, comenta esta línea.
# Para mantener el control desde el repo, lo dejamos aquí:
cp -f "${IMAGE_DIR}/server.properties" "${PERSISTENT_DIR}/server.properties"
cp -f "${IMAGE_DIR}/eula.txt" "${PERSISTENT_DIR}/eula.txt"

# Sobrescribe los plugins solo si hay cambios en el repositorio.
cp -r -f "${IMAGE_DIR}/plugins" "${PERSISTENT_DIR}/" 

# =========================================================================
# 2. Copia Condicional de Archivos BASE (Solo si NO existe el mundo)
# =========================================================================

# Verifica la existencia de un archivo clave (ej. spigot.yml) para determinar el PRIMER inicio
# Usar el directorio 'world' puede ser peligroso si el usuario lo borra para generar uno nuevo
if [ ! -f "${PERSISTENT_DIR}/spigot.yml" ]; then
    echo "Primer inicio detectado. Copiando archivos base del servidor (config, yml, etc.) a /data."
    
    # Lista de archivos/carpetas que deben copiarse al volumen en el primer inicio:
    
    # Copia todo el contenido de /server a /data, excluyendo el .jar y los archivos que ya manejamos arriba.
    # Usaremos 'cp -R -n' para copiar recursivamente pero sin sobreescribir (no-clobber)
    # y 'ls' para listar los contenidos de /server, luego copiamos cada uno EXCEPTO los que ya hemos copiado arriba.
    
    for item in $(ls -A ${IMAGE_DIR}); do
        # Excluir archivos que ya manejamos (paper.jar, eula.txt, server.properties, plugins)
        if [ "$item" != "paper.jar" ] && [ "$item" != "eula.txt" ] && [ "$item" != "server.properties" ] && [ "$item" != "plugins" ]; then
            cp -r -n "${IMAGE_DIR}/$item" "${PERSISTENT_DIR}/"
            echo "${IMAGE_DIR}/$item copiado a ${PERSISTENT_DIR}/"
        fi
    done
    
    echo "Archivos base copiados a /data. El servidor generará world, ops.json, etc. en /data."
fi

# =========================================================================
# 2.5. Forzar Configuración de Proxy (Previene la Reversión de PaperMC)
# =========================================================================

PAPER_GLOBAL_YML="${PERSISTENT_DIR}/config/paper-global.yml"

if [ -f "$PAPER_GLOBAL_YML" ]; then
    sed -i 's/proxy-protocol: false/proxy-protocol: true/' "$PAPER_GLOBAL_YML"
fi

# =========================================================================
# 3. Ejecución del Servidor
# =========================================================================
cd "${PERSISTENT_DIR}"
# Ejecuta el servidor Java como PID 1
exec java ${JAVA_OPTS} ${JAVA_OPTS_GC} -jar ${PERSISTENT_DIR}/paper.jar --nogui