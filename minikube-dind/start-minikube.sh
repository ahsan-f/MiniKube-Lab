#!/bin/bash
set -e

echo "Starting Docker daemon..."
# The `docker:dind` image's ENTRYPOINT typically starts dockerd.
# We just need to wait for it.
until docker info >/dev/null 2>&1; do
  echo "Waiting for Docker daemon to start..."
  sleep 1
done

echo "Docker daemon is running. Starting Minikube..."

# Start minikube using the 'docker' driver
# --force is often needed when running as root in a container
# --wait=true: We want Minikube to be fully ready before proceeding in CI
# --container-name: Give the minikube container a predictable name inside the DinD
minikube start \
  --driver=docker \
  --force \
  --wait=true \
  --memory=4096 \
  --cpus=2 \
  --container-name minikube-cluster

echo "Minikube started. Waiting for cluster to be ready..."
# Wait for the Kubernetes API to be available
kubectl wait --for=condition=ready node/minikube --timeout=5m
# Wait for core components
kubectl wait --namespace=kube-system --for=condition=ready pod -l k8s-app=kube-dns --timeout=5m
kubectl wait --namespace=kube-system --for=condition=ready pod -l k8s-app=kube-proxy --timeout=5m
kubectl wait --namespace=kube-system --for=condition=ready pod -l component=etcd --timeout=5m

echo "Minikube cluster is ready!"

# Keep the container running in the background for CI or interactive use.
# For CI, the workflow will typically run kubectl commands after this script exits.
# This 'sleep infinity' is just to keep the container alive.
sleep infinity & wait $!
