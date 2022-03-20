FROM maven:3.8.4-jdk-8 AS build
ARG version
RUN mkdir app
COPY . /app
WORKDIR app
RUN mvn -Dversion="$version" clean install


FROM openjdk:8-jdk-alpine
ARG version
ARG JAR_FILE=/app/target/spring-$version.jar
EXPOSE 8080
COPY --from=build /${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]