FROM docker:dind

# Install required packages (no duplicate entries)
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

# Versions (adjust as needed)
ARG K8S_VERSION="v1.27.3"
ARG MINIKUBE_VERSION="v1.31.2"

# Install kubectl
RUN echo "Installing kubectl ${K8S_VERSION}" \
    && curl -Lo /tmp/kubectl "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x /tmp/kubectl \
    && mv /tmp/kubectl /usr/local/bin/kubectl

# Install Minikube
RUN echo "Installing minikube ${MINIKUBE_VERSION}" \
    && curl -Lo /tmp/minikube "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64" \
    && chmod +x /tmp/minikube \
    && mv /tmp/minikube /usr/local/bin/minikube

# Copy startup script. Use a path relative to the build context.
# Make sure the file exists at ./minikube-dind/start-minikube.sh (or adjust the path below)
COPY minikube-dind/start-minikube.sh /usr/local/bin/start-minikube.sh

# Ensure the script is executable
RUN chmod +x /usr/local/bin/start-minikube.sh

# Default entrypoint to start Minikube inside DinD
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]
