# Minecraft Server Boilerplate - Docker & PaperMC Optimized
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![PaperMC](https://img.shields.io/badge/PaperMC-High_Performance-181a1b?style=flat&logo=paper&logoColor=white)](https://papermc.io/)
[![Minecraft](https://img.shields.io/badge/Minecraft-Java_Edition-46a546?style=flat&logo=minecraft&logoColor=white)](https://www.minecraft.net/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **Nota**: Este proyecto es un **boilerplate definitivo** diseñado para desplegar servidores de Minecraft de alto rendimiento de manera rápida y eficiente. Utiliza **Docker** para la contenerización y **PaperMC** junto con una suite de plugins de optimización pre-seleccionados.

---

## 📋 Descripción

**Infraestructura Sólida para Servidores de Minecraft**

Este repositorio proporciona una base (boilerplate) optimizada para crear un servidor de Minecraft capaz de soportar aproximadamente **20 jugadores** con recursos de hardware limitados. El objetivo es eliminar el "lag" común mediante configuraciones avanzadas de la JVM (Aikar's Flags), ajustes en el motor del juego y plugins de gestión de recursos.

### 🎯 Propósito del Proyecto

- **Despliegue Rápido**: Levantar un servidor funcional en minutos gracias a Docker Compose.
- **Rendimiento Máximo**: Configuraciones pre-aplicadas para minimizar el uso de CPU y RAM.
- **Mantenibilidad**: Estructura limpia y contenerizada para facilitar actualizaciones y backups.
- **Home Lab**: Ideal para entornos de laboratorio en casa o servidores privados de amigos.

---

## ✨ Características Principales

### 🐳 Arquitectura Dockerizada
- **Aislamiento Total**: El servidor corre en su propio contenedor, sin ensuciar el sistema operativo host.
- **Gestión Sencilla**: Inicio, parada y reinicio con comandos simples de `docker-compose`.
- **Persistencia de Datos**: Volúmenes configurados para mantener seguros los mundos y configuraciones.

### 🚀 Optimizaciones de Rendimiento (Out-of-the-Box)
- **Aikar's Flags**: Parámetros de lanzamiento de Java (`-XX:+UseG1GC...`) ya configurados en el `docker-compose.yml` para una recolección de basura eficiente.
- **Ajustes de Visión**: `view-distance=6` y `simulation-distance=4` para reducir la carga de chunks.
- **Compresión de Red**: Balance optimizado entre CPU y ancho de banda.

### 🛠️ Suite de Plugins Recomendada
El boilerplate está preparado para trabajar con plugins esenciales de optimización (ver sección de configuración):
- **FarmControl**: Control inteligente de granjas y mobs.
- **UltimateAutoRestart**: Gestión de reinicios automáticos para liberar memoria.
- **Chunky**: Pre-generación de mundo para eliminar el lag de exploración.

---

## 🛠️ Stack Tecnológico

- **Container Engine**: Docker & Docker Compose
- **Server Core**: PaperMC (Fork de alto rendimiento de Spigot/Bukkit)
- **Java Runtime**: OpenJDK (versión compatible con la versión de MC elegida)
- **Plugins Core**:
  - FarmControl
  - UltimateAutoRestart
  - Chunky

---

## 📦 Instalación y Uso

### Prerrequisitos
- Docker y Docker Compose instalados en el sistema.
- Git para clonar el repositorio.

### Pasos de Despliegue

1.  **Clonar el repositorio**:
    ```bash
    git clone https://github.com/neocizee/minecraft-server.git
    cd minecraft-server
    ```

2.  **Iniciar el servidor**:
    ```bash
    docker-compose up -d
    ```

3.  **Verificar logs**:
    ```bash
    docker-compose logs -f
    ```


## 📊 Estructura del Proyecto

```
minecraft-server/
├── docker-compose.yml    # Definición del servicio y variables de entorno
├── server.properties     # Configuración base de Minecraft (optimizado)
├── data/                 # Volumen persistente (mundos, plugins, logs)
│   ├── plugins/          # Carpeta de plugins
│   ├── world/            # El mundo de Minecraft
│   ├── spigot.yml        # Configuración de Spigot
│   └── bukkit.yml        # Configuración de Bukkit
├── README.md             # Esta documentación
└── LICENSE               # Licencia del proyecto
```

---

## ⚠️ Consideraciones Importantes

- **Recursos**: Este boilerplate está pensado para servidores pequeños/medianos (aprox. 20 jugadores). Para comunidades más grandes, se requerirá hardware más potente y ajustes adicionales.
- **Seguridad**: Si vas a exponer el servidor a internet, asegúrate de configurar correctamente el firewall y considerar el uso de una whitelist o proxy (como Velocity).
- **Backups**: Aunque Docker facilita la gestión, siempre implementa una estrategia de backups regular para la carpeta `data/`.

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Si tienes sugerencias para mejorar aún más el rendimiento o la estructura del boilerplate, por favor abre un issue o envía un pull request.

---

## 📝 Licencia

Este proyecto se distribuye bajo la **Licencia MIT**.
Esto significa que puedes usar, copiar, modificar, fusionar, publicar, distribuir, sublicenciar y/o vender copias del software, bajo las condiciones de la licencia.

Ver el archivo [LICENSE](LICENSE) para más detalles.

---

## 👨‍💻 Autor [@neocizee](https://github.com/neocizee)

Este proyecto es parte de mi **Home Lab** y portafolio personal, demostrando la aplicación de conocimientos de DevOps y administración de sistemas en entornos lúdicos.
