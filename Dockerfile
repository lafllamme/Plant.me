FROM ollama/ollama:latest

# Install curl and jq
RUN apt-get update && apt-get install -y curl jq

# Create a directory for scripts
RUN mkdir /scripts

# Copy the health check script into the container
COPY scripts/health_check.sh /scripts/health_check.sh
RUN chmod +x /scripts/health_check.sh

# Copy the init script into the container
COPY scripts/init.sh /scripts/init.sh
RUN chmod +x /scripts/init.sh

# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]
