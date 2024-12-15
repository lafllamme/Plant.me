#!/bin/sh

# Define color codes using ANSI escape sequences for better compatibility
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Check if OLLAMA_MODEL is set, default to 'mistral' if not
: "${OLLAMA_MODEL:=mistral}"

# Function to format time in European format
get_time(){
  date +"%d-%m-%Y %H:%M:%S"
}

# Function to run health check
run_health_check(){
  echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${YELLOW}Running health check...${NC}"
  /scripts/health_check.sh
}

# Run the setup script to initialize environment variables if needed
if [ ! -f ".env" ]; then
  echo "[Entrypoint] $(date +"%d-%m-%Y %H:%M:%S") | .env not found. Running setup.sh..."
  /scripts/setup.sh
else
  echo "[Entrypoint] $(date +"%d-%m-%Y %H:%M:%S") | .env file already exists. Skipping setup."
fi

# Start the Ollama server in the background
ollama serve &
OLLAMA_PID=$!

# Wait for the server to be ready
echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${YELLOW}Waiting for Ollama server to start...${NC}"
until curl -s http://localhost:11434/api/tags > /dev/null; do
    sleep 1
done
echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${GREEN}Ollama server started.${NC}"

# Check if the model is already present
if ! ollama list | grep -q "$OLLAMA_MODEL"; then
    echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${YELLOW}Model $OLLAMA_MODEL not found, pulling...${NC}"
    ollama pull "$OLLAMA_MODEL"
    echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${GREEN}Model $OLLAMA_MODEL pulled successfully.${NC}"
else
    echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${GREEN}Model $OLLAMA_MODEL already present.${NC}"
fi

# Check for custom Modelfile and copy it
if [ -f /models/Modelfile ]; then
    echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${YELLOW}Custom Modelfile found, copying to Ollama models directory...${NC}"
    cp /models/Modelfile /root/.ollama/models/
    echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${GREEN}Custom Modelfile copied successfully.${NC}"
else
    # Loop through models directory and copy the first file found
    for model in /models/*; do
        if [ -f "$model" ]; then
            echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${YELLOW}Custom Modelfile found, copying to Ollama models directory...${NC}"
            cp "$model" /root/.ollama/models/Modelfile
            echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${GREEN}Custom Modelfile copied successfully.${NC}"
            break
        fi
    done
fi

# Load the model into memory
echo "[${BLUE}Entrypoint${NC}] $(get_time) | ${YELLOW}Loading model $OLLAMA_MODEL into memory...${NC}"
curl -X POST http://localhost:11434/api/generate -d "{\"model\": \"$OLLAMA_MODEL\"}"

# Run the health check in the background every 30 seconds
while true; do
  run_health_check
  sleep 30
done &

# Wait for the Ollama server to continue running
wait $OLLAMA_PID
