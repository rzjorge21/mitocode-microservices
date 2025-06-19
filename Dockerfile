# Fase de construcción
FROM eclipse-temurin:17-jdk-jammy as builder
WORKDIR /app

# Copiar solo lo necesario para descargar dependencias
COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

# Descargar dependencias (cache separada para optimización)
RUN ./mvnw dependency:go-offline

# Copiar código fuente
COPY src ./src

RUN ./mvnw clean package -DskipTests

# Fase de ejecución
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copiar el JAR desde la fase de construcción
COPY --from=builder /app/target/*.jar app.jar

# Metadatos
LABEL maintainer="rz.jorge21@gmail.com"
LABEL version="1.0"
LABEL description="Microservicio Mitocode"

# Configuración
EXPOSE 8080
ENV JAVA_OPTS="-Xms256m -Xmx512m"
USER 1001

# Punto de entrada
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]