FROM eclipse-temurin:17-jdk-jammy as builder

WORKDIR /app

# 1. Permisos y dependencias
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline

# 2. Código fuente
COPY src ./src

# 3. Compilación y empaquetado
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Metadata
LABEL maintainer="rz.jorge21@gmail.com"
LABEL version="1.0"
LABEL description="Microservicio Mitocode"

# Configuración
ENV JAVA_OPTS="-Xms256m -Xmx512m"
USER 1001
EXPOSE 8080

COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar app.jar"]