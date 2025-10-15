#!/bin/bash
set -e

echo "Starting Docker daemon and waiting for readiness..."
# Wait for the DinD's Docker daemon to be fully ready
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker daemon..."
  sleep 1
done

echo "Docker daemon is running. Starting Minikube..."

# Start minikube using the 'docker' driver
minikube start \
  --driver=docker \
  --force \
  --wait=true \
  --memory=4096 \
  --cpus=2 \
  --container-name minikube-cluster

echo "Minikube started. Waiting for core cluster components to be ready..."
# Wait for a key system component to confirm K8s is functional
# We rely on the external workflow to run the final 'kubectl get nodes' check, but this confirms the internal start is complete.
kubectl wait --namespace=kube-system --for=condition=ready pod -l k8s-app=kube-dns --timeout=5m

echo "Minikube cluster initialization complete. Keeping container alive..."

# CRUCIAL: Use tail -f /dev/null to keep the container running indefinitely
tail -f /dev/null
