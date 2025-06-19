
## Descripción del Proyecto
Este proyecto es una aplicación Spring Boot que implementa un servicio de calculadora básica con operaciones de suma y resta. Fue desarrollado como demostración de un pipeline CI/CD completo que incluye:
-   Pruebas unitarias con cobertura controlada
-   Análisis estático de código con SonarQube
-   Despliegue de imagen en DockerHub
-   Automatización con Jenkins
    
## Características Técnicas

### Configuración Inicial
-   **Tecnología**: Spring Boot 3.5.0
-   **Empaquetado**: JAR
-   **Java**: Versión 17    
-   **Dependencias principales**:
    -   Spring Web
    -   Spring Boot Starter Test
    -   JaCoCo (para reporte de cobertura)
        

### Funcionalidades Implementadas
-   Servicio de suma de números enteros
-   Servicio de resta de números enteros
-   Pruebas unitarias con cobertura >65%
-   Integración continua con Jenkins
-   Análisis de calidad de código con SonarQube
-   Publicación de imagen en Dockerhub bajo el nombre de rzjorge21/mitocode-microservices
    

## Pipeline CI/CD (Jenkinsfile)

El pipeline automatizado consta de las siguientes etapas:

1.  **Build**: Compilación del proyecto Java con Maven    
2.  **Testing**: Ejecución de pruebas unitarias
3.  **Coverage**:
    -   Generación de reporte de cobertura con JaCoCo        
    -   Validación de mínimo 60% de cobertura en líneas de código
4.  **SonarQube Analysis**:
    -   Escaneo estático de código
    -   Envío de métricas a SonarQube
    -   Umbral mínimo configurado al 60% de cobertura    
5.  **Quality Gate**:
    -   Validación de estándares de calidad
    -   Falla el pipeline si no se cumplen los requisitos
6.  **Package**:
    -   Empaquetado del artefacto final (JAR)
    -   Omisión de pruebas (ya ejecutadas en etapas anteriores)
7.  **Build Docker Image**:
    -   Construcción de imagen
8. **Push to DockerHub**:
    -   Publicación de imagen generada a la cuenta personal
9. **Post ejecución**:
    -   Limpieza del workspace
    -   Logout de DockerHub

## Dockerfile
1. Uso de la imagen oficial de Eclipse Temurin (JDK 17)
2. Se estable /app como directorio de trabajo dentro del contenedor
3. Copia de archivos de confiración y otorgamiento de permisos
4. Descarga de dependencias
5. Copia de código fuente
6. Compilación
7. Uso de una imagen más ligera (Solo JRE) con solo lo necesario para la ejecución de la aplicación
8. Configuración de metadatos
9. Configuración de ejecución
10. Configuración y copia de artefacto

### Configuración Requerida

-   **Variables de entorno**:
    -   `SONAR_HOST_URL`: URL del servidor SonarQube
    -   `DOCKERHUB_CREDS`: Credenciales de DockerHub
    -   `DOCKER_IMAGE`: Nombre de imagen a publicar