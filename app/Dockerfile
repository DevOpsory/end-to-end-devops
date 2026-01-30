FROM eclipse-temurin:21-jre AS base

RUN groupadd --system appgroup && useradd --system appuser --group appgroup

WORKDIR /app

RUN chown --recursive appuser:appgroup /app

USER appuser:appgroup

COPY target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]