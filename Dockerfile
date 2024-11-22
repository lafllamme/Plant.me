FROM ollama/ollama:latest

# Install curl
RUN apt-get update && apt-get install -y curl

# Copy the entrypoint script into the image
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to the script
ENTRYPOINT ["/entrypoint.sh"]
