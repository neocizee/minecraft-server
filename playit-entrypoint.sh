#!/bin/sh
set -e

PLAYIT_BIN="/app/playit"

# CRÍTICO: Lee la URL de la variable de entorno ($PLAYIT_URL)
# Si la variable no está definida, usa la URL de fallback (pero el compose la definirá)
DOWNLOAD_URL=${PLAYIT_URL:-"httpsWAR:URL_NO_DEFINIDA"}

if [ ! -f "$PLAYIT_BIN" ]; then
    echo "PlayIt binary not found, downloading from: $DOWNLOAD_URL"
    
    # Usa la variable para la descarga
    curl -fL -o "$PLAYIT_BIN" "$DOWNLOAD_URL"
    
    chmod +x "$PLAYIT_BIN"
    echo "Download complete."
fi

echo "Starting PlayIt agent..."
exec stdbuf -o L "$PLAYIT_BIN"
