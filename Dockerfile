# Start from the OpenJDK 24 base image (matching Java version in pom.xml)
FROM eclipse-temurin:24-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper or use system Maven if not using wrapper
# Copy only necessary files for dependencies first to leverage Docker cache
COPY pom.xml ./
COPY src ./src

# Install Maven and build the application (if not using wrapper)
RUN apk add --no-cache maven && \
    mvn clean package -DskipTests

# Run the JAR
CMD ["java", "-jar", "target/notesapp-docker.jar"]
