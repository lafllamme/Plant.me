#!/bin/sh

# Check if OLLAMA_MODEL is set, default to llama3.2 if not
: "${OLLAMA_MODEL:=llama3.2}"

MODEL_PATH="/root/.ollama/models/$OLLAMA_MODEL"

if [ ! -d "$MODEL_PATH" ]; then
    echo "Model $OLLAMA_MODEL not found, pulling..."
    ollama pull "$OLLAMA_MODEL"
else
    echo "Model $OLLAMA_MODEL already present."
fi

# Start the Ollama server
exec ollama serve
