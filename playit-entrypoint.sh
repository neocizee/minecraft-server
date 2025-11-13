#!/bin/sh
set -e

PLAYIT_BIN="/app/playit"

if [ ! -f "$PLAYIT_BIN" ]; then
    echo "PlayIt binary not found, downloading (con DNS público)..."
    
    # CRÍTICO: Usar la URL de descarga correcta
    curl -fL -o "$PLAYIT_BIN" https://playit.cloud/api/v1/agent/downloads/playit-linux-x86_64
    
    chmod +x "$PLAYIT_BIN"
    echo "Download complete."
fi

echo "Starting PlayIt agent..."
exec stdbuf -o L "$PLAYIT_BIN"
