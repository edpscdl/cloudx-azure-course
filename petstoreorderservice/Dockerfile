FROM maven:3.9.9-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package

FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENV APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=ec1c6bf9-d84d-4915-8505-2eb69e10542e;IngestionEndpoint=https://eastus-8.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/;ApplicationId=9cba63c9-e0db-40b9-8baa-810b9d9cd281
CMD ["java", "-jar", "app.jar"]