# ... (Steps 1-11)
# ...

# Step 12: Set the container's entrypoint to run the Minikube startup script
# This ensures that when the container starts, it executes your script.
ENTRYPOINT ["/usr/local/bin/start-minikube.sh"] 

# NOTE: The base 'docker:dind' image usually has CMD ["dockerd-entrypoint.sh"]
# If you are using CMD, make sure it calls dockerd-entrypoint.sh before your script.
# Using ENTRYPOINT as above is simpler for custom startup logic.
