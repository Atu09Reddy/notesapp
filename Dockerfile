# === Build Stage ===
FROM eclipse-temurin:24-jdk-alpine as builder

WORKDIR /app

# Install Maven and dependencies
RUN apk add --no-cache maven

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# === Runtime Stage ===
FROM eclipse-temurin:24-jdk-alpine

WORKDIR /app

# Copy only the built jar from the builder stage
COPY --from=builder /app/target/notesapp-docker.jar .

# Run the app
CMD ["java", "-jar", "notesapp-docker.jar"]

