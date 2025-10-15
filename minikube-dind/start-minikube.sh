#!/bin/bash
set -e

echo "Starting Docker daemon and waiting for readiness..."
# Wait for the DinD's Docker daemon to be fully ready
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker daemon..."
  sleep 1
done

echo "Docker daemon is running. Giving it a moment to stabilize..."
sleep 5 # Added buffer

echo "Starting Minikube..."

# Start minikube with increased resources and less aggressive internal wait
minikube start \
  --driver=docker \
  --force \
  --wait=false \
  --memory=6000 \
  --cpus=3 \
  --container-name minikube-cluster

echo "Minikube start command executed. Relying on external check to confirm readiness."

# CRUCIAL: Use tail -f /dev/null to keep the container running indefinitely
tail -f /dev/null
