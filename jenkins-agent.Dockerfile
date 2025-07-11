# jenkins-agent.Dockerfile
FROM jenkins/jenkins:lts-jdk17 # Or a suitable base image like 'jenkins/agent:jdk17' or even a custom image if you prefer more control

# Install Docker CLI
# Install necessary packages for Docker CLI (e.g., ca-certificates, curl, gnupg, lsb-release)
# (Specific commands might vary based on the base image, this is for Debian/Ubuntu based)
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    mkdir -m 0755 -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli

# Install AWS CLI v2
RUN apt-get update && apt-get install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    unzip /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install --install-dir /usr/local/aws-cli --bin-dir /usr/local/bin && \
    rm -rf /tmp/awscliv2.zip /tmp/aws && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install kubectl (example for Linux x86_64)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

