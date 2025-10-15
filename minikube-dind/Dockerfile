# Use a Docker-in-Docker base image
FROM docker:dind

# Install required packages (curl, bash, etc.)
# FIX: Use --no-cache with apk add to prevent stale cache issues during the build
# Also include core dependencies for Minikube stability on Alpine
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
ARG K8S_VERSION="v1.27.3" # Pinned stable version
ARG MINIKUBE_VERSION="v1.31.2" 

# --- Install Kubectl ---
RUN echo "Installing kubectl ${K8S_VERSION}" \
    && curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" \
    && chmod +x kubectl \
    && install kubectl /usr/local/bin/kubectl \
    && rm kubectl

# --- Install Minikube ---
# Ensures the binary is correctly placed and executable.
RUN echo "Installing minikube ${MINIKUBE_VERSION}" \
    && curl -Lo minikube "https://storage.googleapis.com/minikube/releases/${MINIKUBE_VERSION}/minikube-linux-amd64" \
    && chmod +x minikube \
    && install minikube /usr/local/bin/minikube \
    && rm minikube
    
# Verification (Optional, but good for local testing)
# RUN ls -l /usr/local/bin/minikube && /usr/local/bin/minikube version

# Add a script to start Minikube
COPY minikube-dind/start-minikube.sh /usr/local/bin/start-minikube.sh
RUN chmod +x /usr/local/bin/start-minikube.sh

# Set the entrypoint to the script
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"]

# Default command can be a simple shell for interactive use
CMD ["bash"]
