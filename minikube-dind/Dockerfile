# Use a Docker-in-Docker base image
FROM docker:dind

# Install required packages (curl, bash, coreutils, etc.)
# FIX: Using --no-cache for stable package installs on Alpine and adding dependencies
RUN apk update \
    && apk add --no-cache \
    bash \
    curl \
    socat \
    git \
    shadow \
    e2fsprogs \
    coreutils \
    && rm -rf /var/cache/apk/*

# Define versions for Minikube and Kubectl
ARG K8S_VERSION="v1.27.3" 
ARG MINIKUBE_VERSION="v1.31.2" 

# --- Install Kubectl ---
RUN echo "Installing kubectl ${K8S_VERSION}" \
    && curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && install kubectl /usr/local/bin/kubectl \
    && rm kubectl

# --- Install Minikube ---
RUN echo "Installing minikube ${MINIKUBE_VERSION}" \
    && curl -Lo minikube "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64" \
    && chmod +x minikube \
    && install minikube /usr/local/bin/minikube \
    && rm minikube
    
# --- CRITICAL BUILD CHECK SCRIPT ---
# This ensures the binaries are correctly installed and executable immediately after download.
RUN echo "--- Verifying Minikube and Kubectl Installation ---" && \
    if [ -f /usr/local/bin/minikube ] && [ -x /usr/local/bin/minikube ]; then \
        echo "Minikube binary exists and is executable." && \
        /usr/local/bin/minikube version; \
    else \
        echo "FATAL ERROR: Minikube binary not found or not executable."; \
        exit 1; \
    fi && \
    if [ -f /usr/local/bin/kubectl ] && [ -x /usr/local/bin/kubectl ]; then \
        echo "Kubectl binary exists and is executable." && \
        /usr/local/bin/kubectl version --client --output=json; \
    else \
        echo "FATAL ERROR: Kubectl binary not found or not executable."; \
        exit 1; \
    fi && \
    echo "--- Minikube and Kubectl installation verified. ---"

# Add and make the startup script executable
COPY minikube-dind/start-minikube.sh /usr/local/bin/start-minikube.sh
RUN chmod +x /usr/local/bin/start-minikube.sh

ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]
CMD ["bash"]
