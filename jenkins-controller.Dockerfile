# Dockerfile for your Jenkins Server (e.g., jenkins-controller.Dockerfile)
FROM jenkins/jenkins:lts-jdk17

# Switch to root user temporarily to install system-level packages
USER root

# Install necessary packages for AWS CLI, curl, unzip, and apt-get cleanup
RUN apt-get update && \
    apt-get install -y curl unzip apt-transport-https ca-certificates gnupg lsb-release && \
    # Download and install AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin && \
    rm -rf /tmp/awscliv2.zip /tmp/aws && \
    # Install Docker CLI (client only, as Docker daemon runs on host)
    mkdir -m 0755 -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    # Clean up apt caches to reduce image size
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to jenkins user
USER jenkins

# Copy Jenkins plugins if you manage them this way (optional)
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN /usr/local/bin/install-plugins.sh < plugins.txt