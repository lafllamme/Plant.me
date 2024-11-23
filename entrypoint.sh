#!/bin/sh

# Check if OLLAMA_MODEL is set, default to 'mistral' if not
: "${OLLAMA_MODEL:=mistral}"

# Start the Ollama server in the background
ollama serve &
OLLAMA_PID=$!

# Wait for the server to be ready
echo "Waiting for the Ollama server to start..."
until curl -s http://localhost:11434/api/tags > /dev/null; do
    sleep 1
done
echo "Ollama server started."

# Check if the model is already present
if ! ollama list | grep -q "$OLLAMA_MODEL"; then
    echo "Model $OLLAMA_MODEL not found, pulling..."
    ollama pull "$OLLAMA_MODEL"
    echo "Model $OLLAMA_MODEL pulled successfully."
else
    echo "Model $OLLAMA_MODEL already present."
fi

# Load the model into memory
echo "Loading model $OLLAMA_MODEL into memory..."
curl -X POST http://localhost:11434/api/generate -d "{\"model\": \"$OLLAMA_MODEL\"}"

# Wait for the background Ollama server process to keep running
wait $OLLAMA_PID
