# Use a Docker-in-Docker base image
FROM docker:dind

# Install required packages (curl, bash, etc.)
RUN apk update && apk add \
    bash \
    curl \
    socat \
    git \
    && rm -rf /var/cache/apk/*

# Define versions for Minikube and Kubectl
# FIX: Pin to a stable K8s version known to work well in DinD (e.g., v1.27.3)
ARG K8S_VERSION="v1.27.3" 
ARG MINIKUBE_VERSION="v1.31.2" 

# Download and install kubectl
RUN curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# Download and install Minikube
RUN curl -LO "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64" \
    && install minikube-linux-amd64 /usr/local/bin/minikube \
    && rm minikube-linux-amd64

# Add a script to start Minikube
COPY minikube-dind/start-minikube.sh /usr/local/bin/start-minikube.sh
RUN chmod +x /usr/local/bin/start-minikube.sh

# Set the entrypoint to the script
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]

# Default command can be a simple shell for interactive use
CMD ["bash"]
