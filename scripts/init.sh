#!/bin/sh

# Define colors (POSIX compliant ANSI escape codes)
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Function to format time in European format
get_time(){
  date +"%d-%m-%Y %H:%M:%S"
}

# Check if .env or .env.local exists
if [ ! -f ".env" ] && [ ! -f ".env.local" ]; then
  echo "${GREEN}[Init]$(get_time)${NC}: .env file not found. Running setup..."

  # Ask for HF API token
  echo "${YELLOW}What is your Hugging Face API Token?${NC}"
  read -r HF_API_TOKEN
  : "${HF_API_TOKEN:="<YOUR_HF_API_TOKEN>"}"  # Default if no input

  # Ask for OLLAMA API Key
  echo "${YELLOW}What is your Ollama API Key?${NC}"
  read -r OLLAMA_API_KEY
  : "${OLLAMA_API_KEY:="<YOUR_OLLAMA_API_KEY>"}"  # Default if no input

  # Ask for Ollama Model (default is mistral)
  echo "${YELLOW}Which model do you want to use?${NC} (Default is 'mistral')"
  read -r OLLAMA_MODEL
  : "${OLLAMA_MODEL:="mistral"}"  # Default if no input

  # Create the .env file
  echo "${GREEN}[Init]$(get_time)${NC}: Creating .env file..."
  echo "HF_API_TOKEN=$HF_API_TOKEN" > .env
  echo "OLLAMA_API_KEY=$OLLAMA_API_KEY" >> .env
  echo "OLLAMA_MODEL=$OLLAMA_MODEL" >> .env
  echo "${GREEN}[Init]$(get_time)${NC}: .env file created successfully."

  # Final confirmation with a green checkmark emoji and file content
  echo "${GREEN}✅ Setup Complete!$(get_time)"
  echo "${GREEN}Here is the content of your .env file:${NC}"
  cat .env
else
  echo "${GREEN}[Init]$(get_time)${NC}: .env or .env.local file already exists. Skipping setup."
  echo "Current .env content:"
  cat .env
fi

# Run the main application or any other required tasks
