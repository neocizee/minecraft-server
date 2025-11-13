#!/bin/sh
set -e

PLAYIT_BIN="/app/playit"

if [ ! -f "$PLAYIT_BIN" ]; then
    echo "PlayIt binary not found, downloading from Playit.cloud..."
    curl -fL -o "$PLAYIT_BIN" https://playit.cloud/api/v1/agent/downloads/playit-linux-x86_64
    chmod +x "$PLAYIT_BIN"
    echo "Download complete."
fi

echo "Starting PlayIt agent. Looking for claim code..."
# CRÍTICO: El uso de 'stdbuf -o L' fuerza el streaming de logs.
exec stdbuf -o L "$PLAYIT_BIN"
