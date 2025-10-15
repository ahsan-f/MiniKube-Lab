#!/bin/bash
set -e

echo "Starting Docker daemon and waiting for readiness..."
# Wait for the DinD's Docker daemon to be fully ready
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker daemon..."
  sleep 1
done

echo "Docker daemon is running. Giving it a moment to stabilize..."
sleep 5

# --- AGGRESSIVE DEBUGGING START ---
echo "--- PATH DEBUG ---"
# Runtime check
if [ ! -f /usr/local/bin/minikube ]; then
  echo "::error::FATAL: /usr/local/bin/minikube does not exist."
  ls -l /usr/local/bin/
  exit 1
fi

if ! /usr/local/bin/minikube version; then
  echo "minikube version check failed. Error running binary."
  exit 1
fi
echo "minikube binary check passed. Proceeding with start."
echo "------------------"
# --- AGGRESSIVE DEBUGGING END ---

echo "Starting Minikube..."

# Use stable K8s version and --preload for maximum stability in CI. 
# --preload ensures necessary K8s images are pulled before starting components.
minikube start \
  --driver=docker \
  --kubernetes-version=v1.27.3 \
  --force \
  --preload \
  --wait=false \
  --container-name minikube-cluster

echo "Minikube start command executed. Relying on external check to confirm readiness."

# CRITICAL: Keep the container running indefinitely for external access (CI/Compose)
tail -f /dev/null
