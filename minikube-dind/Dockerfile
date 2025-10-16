# Dockerfile
FROM docker:dind

# Install required packages
RUN apk update && apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    bash \
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

# Copy startup script
COPY start-minikube.sh /usr/local/bin/start-minikube.sh
RUN chmod +x /usr/local/bin/start-minikube.sh

# Optional: expose entrypoint for easy run
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]
