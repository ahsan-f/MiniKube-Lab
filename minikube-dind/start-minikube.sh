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
# Check if the binary exists (must pass after the Dockerfile fix)
if [ ! -f /usr/local/bin/minikube ]; then
  echo "::error::FATAL: /usr/local/bin/minikube does not exist."
  ls -l /usr/local/bin/
  exit 1
fi

if ! /usr/local/bin/minikube version; then
  echo "::error::FATAL: minikube binary is not executable or failed to run."
  exit 1
fi
echo "minikube binary check passed. Proceeding with start."
echo "------------------"
# --- AGGRESSIVE DEBUGGING END ---

echo "Starting Minikube..."

# Use stable K8s version and --preload to combat network instability in CI
minikube start \
  --driver=docker \
  --kubernetes-version=v1.27.3 \
  --force \
  --preload \
  --wait=false \
  --container-name minikube-cluster

echo "Minikube start command executed. Relying on external check to confirm readiness."

tail -f /dev/null
