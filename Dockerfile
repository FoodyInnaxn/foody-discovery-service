# Use the official Gradle image as the builder stage
FROM gradle:8.6.0-jdk21-alpine AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY build.gradle /workspace
COPY settings.gradle /workspace
COPY src /workspace/src
RUN gradle build --no-daemon

# Use OpenJDK 21
FROM openjdk:21

COPY --from=builder /workspace/build/libs/*.jar app.jar

EXPOSE 8761
ENTRYPOINT ["java", "-jar", "/app.jar"]