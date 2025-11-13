#!/bin/sh
set -e

# Define la ruta del binario DENTRO del volumen persistente
PLAYIT_BIN="/app/playit"

# Si el binario de playit NO existe en el volumen...
if [ ! -f "$PLAYIT_BIN" ]; then
    echo "PlayIt binary not found, downloading (con DNS público y URL corregida)..."
    
    # CRÍTICO: Usar la URL de descarga correcta
    curl -fL -o "$PLAYIT_BIN" https://playit.cloud/api/v1/agent/downloads/playit-linux-x86_64
    
    chmod +x "$PLAYIT_BIN"
    echo "Download complete."
fi

echo "Starting PlayIt agent..."
# Ejecuta el binario usando stdbuf para forzar la salida de logs (el código de claim)
exec stdbuf -o L "$PLAYIT_BIN"
