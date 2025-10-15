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

# FIX: Removed explicit --memory and --cpus limits. Let the DinD container inherit from the host runner.
minikube start \
  --driver=docker \
  --force \
  --wait=false \
  --container-name minikube-cluster

echo "Minikube start command executed. Relying on external check to confirm readiness."

# CRUCIAL: Use tail -f /dev/null to keep the container running indefinitely
tail -f /dev/null
