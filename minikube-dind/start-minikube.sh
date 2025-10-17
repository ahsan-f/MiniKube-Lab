#!/bin/bash
set -e

# --- 1. Start the inner Docker Daemon ---
echo "Starting inner Docker daemon in background..."
# Run the Docker daemon in the background and redirect logs to a file for diagnostics
/usr/local/bin/dockerd-entrypoint.sh dockerd > /var/log/dockerd.log 2>&1 &
DOCKERD_PID=$!

# --- 2. Wait for Docker to be ready (Crucial for DinD) ---
echo "Waiting for Docker socket to be ready..."
TIMEOUT=90  # Give Docker up to 90 seconds to start
count=0

while ! docker info >/dev/null 2>&1 && [ $count -lt $TIMEOUT ]; do
    echo "[minikube-dind-start] Docker daemon not ready yet. Retrying in 1s..."
    sleep 1
    count=$((count + 1))
done

if [ $count -ge $TIMEOUT ]; then
    echo "--- ERROR: Inner Docker daemon failed to start within $TIMEOUT seconds. ---"
    echo "Dumping Docker daemon logs:"
    cat /var/log/dockerd.log
    kill $DOCKERD_PID
    exit 1
fi
echo "Inner Docker daemon is ready."

# --- 3. Start Minikube ---
echo "Starting Minikube using the 'docker' driver..."
# Use --wait to ensure the control plane is ready before the script continues
# Use --force for CI environments where Minikube might have stale data
minikube start --driver=docker --force --wait=true

echo "Minikube is operational."

# --- 4. Keep the container alive ---
# Wait for the background Docker daemon process to finish.
# Since 'dockerd' runs indefinitely, this keeps the container alive.
wait $DOCKERD_PID
