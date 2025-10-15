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

# FIX: Removed explicit --memory and --cpus limits for resource stability
minikube start \
  --driver=docker \
  --force \
  --wait=false \
  --container-name minikube-cluster

echo "Minikube start command executed. Relying on external check to confirm readiness."

# CRUCIAL: Use tail -f /dev/null to keep the container running indefinitely
tail -f /dev/null
