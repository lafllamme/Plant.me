#!/bin/sh


#TODO: Clean up the entrypoint script
#TODO: Add support for multiple models (LLaVA)

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

# Check if we a custom Modelfile under /models/Modelfile
# Name can be different, but it should be a Modelfile
# So we check if there is any file or a file with the name Modelfile
# Then we copy it to the Ollama models directory
if [ -f /models/Modelfile ]; then
    echo "Custom Modelfile found, copying to Ollama models directory..."
    cp /models/Modelfile /root/.ollama/models/
    echo "Custom Modelfile copied successfully."
elif for model in /models/*; do
    if [ -f "$model" ]; then
        echo "Custom Modelfile found, copying to Ollama models directory..."
        echo "DEBUG: $model"
        cp "$model" /root/.ollama/models/Modelfile
        echo "Custom Modelfile copied successfully."
        break
    fi
done; then
    echo "Custom Modelfile copied successfully."
else
    echo "No custom Modelfile found."
fi

# Load the model into memory
echo "Loading model $OLLAMA_MODEL into memory..."
curl -X POST http://localhost:11434/api/generate -d "{\"model\": \"$OLLAMA_MODEL\"}"

# Wait for the background Ollama server process to keep running
wait $OLLAMA_PID
