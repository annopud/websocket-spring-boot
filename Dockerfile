FROM maven:3.9.9-eclipse-temurin-17-focal AS build

WORKDIR /app

COPY . .

RUN mvn clean package -Dmaven.test.skip=true

FROM eclipse-temurin:17-jre-jammy AS final

USER root

RUN groupadd -g 30000 java && useradd -u 30000 -g java java

COPY --from=build --chown=java:java /app/target/*.jar /app/app.jar

USER java

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]
