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

# 4. CRÍTICO: Comando de inicio simplificado.
# El agente se iniciará y te dará el código de claim.
CMD ["playit"]