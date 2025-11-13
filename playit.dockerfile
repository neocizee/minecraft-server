# Usamos una imagen base con capacidad de instalación (ej. Ubuntu o Debian)
FROM ubuntu:latest

# Instalar dependencias
RUN apt-get update && apt-get install -y curl gnupg2

# Instalar playit.gg
# 1. Añade la llave GPG
RUN curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null

# 2. Añade el repositorio
RUN echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | tee /etc/apt/sources.list.d/playit-cloud.list

# 3. Actualiza e instala playit
RUN apt-get update && apt-get install -y playit

# Puerto TCP predeterminado de Minecraft
ENV MINECRAFT_PORT 25565

# El comando de inicio
# NOTA: El primer inicio te pedirá el código de claim.
CMD ["playit", "--local-ip", "minecraft_server", "tcp", "25565"]