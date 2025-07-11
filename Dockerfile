# Start from OpenJDK 24 Alpine base image
FROM eclipse-temurin:24-jdk-alpine

# Install dependencies: curl, unzip, bash, python3, pip, and AWS CLI
RUN apk add --no-cache curl unzip bash python3 py3-pip maven \
    && pip3 install --upgrade pip \
    && pip3 install awscli

# Set working directory
WORKDIR /app

# Copy your Maven files and source code
COPY pom.xml ./
COPY src ./src

# Build the application, skipping tests
RUN mvn clean package -DskipTests

# Run your application
CMD ["java", "-jar", "target/notesapp-docker.jar"]


