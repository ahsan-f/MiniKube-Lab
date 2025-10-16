#!/bin/bash
set -euo pipefail

LOG_PREFIX="[minikube-dind-start]"

echo "$LOG_PREFIX Waiting for inner Docker daemon to be ready..."
until docker info >/dev/null 2>&1; do
  echo "$LOG_PREFIX Docker not ready yet..."
  sleep 1
done

echo "$LOG_PREFIX Docker is ready."
echo "$LOG_PREFIX Verifying binaries..."
if [ ! -x /usr/local/bin/minikube ]; then
  echo "$LOG_PREFIX ERROR: minikube not found or not executable at /usr/local/bin/minikube" >&2
  exit 1
fi
if [ ! -x /usr/local/bin/kubectl ]; then
  echo "$LOG_PREFIX ERROR: kubectl not found or not executable at /usr/local/bin/kubectl" >&2
  exit 1
fi

echo "$LOG_PREFIX Binaries verified."
/usr/local/bin/minikube version
/usr/local/bin/kubectl version --client --output=json

echo "$LOG_PREFIX Starting Minikube with docker driver..."
if ! /usr/local/bin/minikube start \
  --driver=docker \
  --kubernetes-version=${K8S_VERSION:-v1.27.3} \
  --cpus=2 \
  --memory=4096 \
  --log_dir=/var/log/minikube \
  --alsologtostderr \
  --v=2; then
  echo "$LOG_PREFIX Minikube start failed. Collecting diagnostics..."
  /usr/local/bin/minikube status || true
  /usr/local/bin/minikube logs || true
  /usr/local/bin/kubectl version --client || true
  /usr/local/bin/kubectl get pods -A --ignore-not-found || true
  exit 1
fi

echo "$LOG_PREFIX Minikube start command issued. Waiting for API readiness..."
API_TIMEOUT=600
SLEEP_SEC=5
ELAPSED=0

while true; do
  if /usr/local/bin/kubectl get nodes >/dev/null 2>&1; then
    echo "$LOG_PREFIX Kubernetes API is ready."
    break
  fi
  ELAPSED=$((ELAPSED + SLEEP_SEC))
  if [ "$ELAPSED" -ge "$API_TIMEOUT" ]; then
    echo "$LOG_PREFIX API did not become ready within ${API_TIMEOUT}s."
    /usr/local/bin/minikube logs || true
    exit 1
  fi
  sleep "$SLEEP_SEC"
done

echo "$LOG_PREFIX Minikube is up and API is accessible."
