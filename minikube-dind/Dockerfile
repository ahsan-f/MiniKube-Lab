# minikube-dind/Dockerfile

# Stage 1: Setup Minikube and required tools
# Use the official Docker-in-Docker image as the base
FROM docker:dind

# Install necessary packages (bash, curl, utilities, git)
# These were inferred from the build log steps [2/6]
RUN apk update && apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    shadow \
    e2fsprogs \
    coreutils \
    git \
    socat \
    libstdc++ \
    libgcc \
    gcompat \
 && rm -rf /var/cache/apk/*

# Install kubectl (v1.27.3 was in the original log)
RUN echo "Installing kubectl v1.27.3" \
    && curl -Lo /tmp/kubectl "https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl" \
    && chmod +x /tmp/kubectl \
    && mv /tmp/kubectl /usr/local/bin/kubectl

# Install minikube (v1.31.2 was in the original log)
RUN echo "Installing minikube v1.31.2" \
    && curl -Lo /tmp/minikube "https://storage.googleapis.com/minikube/releases/v1.31.2/minikube-linux-amd64" \
    && chmod +x /tmp/minikube \
    && mv /tmp/minikube /usr/local/bin/minikube

# Copy the custom startup script (start-minikube.sh)
COPY minikube-dind/start-minikube.sh /usr/local/bin/start-minikube.sh
RUN chmod +x /usr/local/bin/start-minikube.sh

# Set the Entrypoint to the custom script
# This script must start 'dockerd' in the background, wait for it, and then start 'minikube'.
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]
