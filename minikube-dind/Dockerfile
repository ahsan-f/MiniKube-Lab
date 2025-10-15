# Use a Docker-in-Docker base image
FROM docker:dind

# Install required packages (curl, bash, etc.)
RUN apk update && apk add \
    bash \
    curl \
    socat \
    git \
    shadow \
    && rm -rf /var/cache/apk/*

# Define versions for Minikube and Kubectl
ARG K8S_VERSION="v1.27.3" # Recommended stable version
ARG MINIKUBE_VERSION="v1.31.2" 

# --- Install Kubectl ---
RUN curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# --- Install Minikube ---
# Note: minikube-linux-amd64 is the correct binary name for the generic x86_64 architecture
RUN curl -LO "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64" \
    && chmod +x minikube-linux-amd64 \
    && mv minikube-linux-amd64 /usr/local/bin/minikube

# Add a script to start Minikube
COPY minikube-dind/start-minikube.sh /usr/local/bin/start-minikube.sh
RUN chmod +x /usr/local/bin/start-minikube.sh

# Set the entrypoint to the script
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]

# Default command can be a simple shell for interactive use
CMD ["bash"]
