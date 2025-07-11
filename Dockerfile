FROM eclipse-temurin:24-jdk-alpine

# Install required packages for AWS CLI v2
RUN apk add --no-cache curl unzip bash python3 py3-pip maven groff less

# Download and install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

WORKDIR /app

COPY pom.xml ./
COPY src ./src

RUN mvn clean package -DskipTests

CMD ["java", "-jar", "target/notesapp-docker.jar"]



