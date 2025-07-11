# Use a smaller base image for production if possible, e.g., for Alpine based JRE
FROM eclipse-temurin:24-jdk-alpine

# Install build dependencies and runtime dependencies
# Combine RUN commands to reduce image layers
RUN apk add --no-cache \
    curl \
    unzip \
    bash \
    python3 \
    py3-pip \
    maven \
    groff \
    less && \
    # Download and install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin && \
    rm -rf /tmp/awscliv2.zip /tmp/aws && \
    # Clean up apk cache
    rm -rf /var/cache/apk/*

# Set working directory for the application
WORKDIR /app

# Copy pom.xml first to leverage Docker cache for dependencies
COPY pom.xml ./

# Download dependencies (only if pom.xml changes)
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
# Use -DskipTests to skip tests during the build, which is common in Docker builds
RUN mvn clean package -DskipTests

# Expose the port your application listens on
EXPOSE 8080

# Command to run the application
# Ensure the JAR name matches what mvn clean package produces (e.g., notesapp-docker.jar or notesapp-0.0.1-SNAPSHOT.jar)
CMD ["java", "-jar", "target/notesapp-docker.jar"]



