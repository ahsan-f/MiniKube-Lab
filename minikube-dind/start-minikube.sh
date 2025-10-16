#!/bin/bash
set -euo pipefail

# Environment-driven defaults
K8S_VERSION="${K8S_VERSION:-v1.27.3}"
CPUS="${CPUS:-2}"
MEMORY_MB="${MEMORY_MB:-4096}"
LOG_PREFIX="[minikube-dind-start]"

echo "${LOG_PREFIX} Waiting for inner Docker daemon to be ready..."
until docker info >/dev/null 2>&1; do
  echo "${LOG_PREFIX} Docker daemon not ready yet. Retrying..."
  sleep 1
done
echo "${LOG_PREFIX} Docker daemon is ready."

echo "${LOG_PREFIX} Verifying required binaries..."
if [ ! -x /usr/local/bin/minikube ]; then
  echo "${LOG_PREFIX} ERROR: minikube not found or not executable at /usr/local/bin/minikube" >&2
  ls -l /usr/local/bin/minikube || true
  exit 1
fi
if [ ! -x /usr/local/bin/kubectl ]; then
  echo "${LOG_PREFIX} ERROR: kubectl not found or not executable at /usr/local/bin/kubectl" >&2
  ls -l /usr/local/bin/kubectl || true
  exit 1
fi

echo "${LOG_PREFIX} Binaries verified."
/usr/local/bin/minikube version
/usr/local/bin/kubectl version --client --output=json

echo "${LOG_PREFIX} Starting Minikube with docker driver..."
MINIKUBE_CMD=( 
  start
  --driver=docker
  --kubernetes-version="${K8S_VERSION}"
  --cpus="${CPUS}"
  --memory="${MEMORY_MB}"
  --log_dir=/var/log/minikube
  --alsologtostderr
  --v=2
)

if ! /usr/local/bin/minikube "${MINIKUBE_CMD[@]}"; then
  echo "${LOG_PREFIX} Minikube start failed. Collecting diagnostics..." >&2
  /usr/local/bin/minikube status || true
  /usr/local/bin/minikube logs || true
  /usr/local/bin/kubectl version --client || true
  /usr/local/bin/kubectl get pods -A --ignore-not-found || true
  exit 1
fi

echo "${LOG_PREFIX} Minikube start command issued. Waiting for Kubernetes API readiness..."

API_TIMEOUT=600
SLEEP_SEC=5
ELAPSED=0

while true; do
  if /usr/local/bin/kubectl get nodes >/dev/null 2>&1; then
    echo "${LOG_PREFIX} Kubernetes API is ready. Cluster is up."
    break
  fi

  ELAPSED=$((ELAPSED + SLEEP_SEC))
  if [ "$ELAPSED" -ge "$API_TIMEOUT" ]; then
    echo "${LOG_PREFIX} ERROR: API server did not become ready within ${API_TIMEOUT}s."
    echo "${LOG_PREFIX} Collecting final diagnostics..."
    /usr/local/bin/minikube status || true
    /usr/local/bin/minikube logs || true
    /usr/local/bin/kubectl version --client || true
    /usr/local/bin/kubectl get pods -A || true
    exit 1
  fi

  sleep "$SLEEP_SEC"
done

echo "${LOG_PREFIX} Minikube is up and the Kubernetes API is accessible."
