version: '3.8'

services:
  minikube-ci-env:
    # Use the local Dockerfile to build the Minikube DinD image
    build: 
      context: .
      dockerfile: minikube-dind/Dockerfile
    
    # CRITICAL: DinD requires privileged mode to manage the nested Docker daemon
    privileged: true
    
    # Use a fixed name for easy management and access
    container_name: minikube-ci-env

    # Volumes necessary for DinD to function correctly and persist data
    volumes:
      - minikube-certs:/certs/client
      - minikube-data:/var/lib/docker
    
    # This prevents the container from exiting
    tty: true
    stdin_open: true
    # Expose necessary ports if you need to access Minikube externally
    # ports:
    #   - "8080:8080" 

volumes:
  minikube-certs:
  minikube-data:
