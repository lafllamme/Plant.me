FROM ollama/ollama:latest

# Install curl
RUN apt-get update && apt-get install -y curl

# Create a directory for scripts
RUN mkdir /scripts

# Copy the health check into the container
COPY scripts/health_check.sh /scripts/health_check.sh
RUN chmod +x /scripts/health_check.sh

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]
