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

# Function to check if a file is empty
is_file_empty() {
  # Check if there is any content in the file other than comments
  grep -q '[^#]*=' "$1"
  return $?
}

# Debugging: Print the current directory structure
echo "${GREEN}[Debug]$(get_time)${NC}: Checking current directory structure..."
ls -lah

# Debugging: Check if the .env and .env.local files exist
echo "${GREEN}[Debug]$(get_time)${NC}: Checking if .env exists and is not empty..."
if [ -f ".env" ]; then
  echo "${GREEN}[Debug]$(get_time)${NC}: .env exists."
else
  echo "${RED}[Debug]$(get_time)${NC}: .env does not exist."
fi

echo "${GREEN}[Debug]$(get_time)${NC}: Checking if .env.local exists and is not empty..."
if [ -f ".env.local" ]; then
  echo "${GREEN}[Debug]$(get_time)${NC}: .env.local exists."
else
  echo "${RED}[Debug]$(get_time)${NC}: .env.local does not exist."
fi

# Create the .env file if it doesn't exist or is empty
if [ ! -f ".env" ] || ! is_file_empty ".env"; then
  echo "${GREEN}[Create]$(get_time)${NC}: .env file not found or empty. Creating .env file... 📄"
  touch .env
fi

# Create the .env.local file if it doesn't exist or is empty
if [ ! -f ".env.local" ] || ! is_file_empty ".env.local"; then
  echo "${GREEN}[Create]$(get_time)${NC}: .env.local file not found or empty. Creating .env.local file... 📄"
  touch .env.local
fi

# Ask for Hugging Face API token
echo "${YELLOW}What is your Hugging Face API Token? 🧑‍💻${NC}"
read -r HF_API_TOKEN
: "${HF_API_TOKEN:="<YOUR_HF_API_TOKEN>"}"  # Default if no input

# Ask for Ollama API Key
echo "${YELLOW}What is your Ollama API Key? 🔑${NC}"
read -r OLLAMA_API_KEY
: "${OLLAMA_API_KEY:="<YOUR_Ollama_API_KEY>"}"  # Default if no input

# Ask for Ollama Model (default is mistral)
echo "${YELLOW}Which model do you want to use? 💡${NC} (Default is 'mistral')"
read -r OLLAMA_MODEL
: "${OLLAMA_MODEL:="mistral"}"  # Default if no input

# Write values into .env
echo "${GREEN}[Create]$(get_time)${NC}: Writing to .env file... 📄"
echo "HF_API_TOKEN=$HF_API_TOKEN" > .env
echo "OLLAMA_API_KEY=$OLLAMA_API_KEY" >> .env
echo "OLLAMA_MODEL=$OLLAMA_MODEL" >> .env
echo "${GREEN}[Create]$(get_time)${NC}: .env file populated successfully. ✅"

# Write values into .env.local
echo "${GREEN}[Create]$(get_time)${NC}: Writing to .env.local file... 📄"
echo "HF_API_TOKEN=$HF_API_TOKEN" > .env.local
echo "OLLAMA_API_KEY=$OLLAMA_API_KEY" >> .env.local
echo "OLLAMA_MODEL=$OLLAMA_MODEL" >> .env.local
echo "${GREEN}[Create]$(get_time)${NC}: .env.local file populated successfully. ✅"

# Final confirmation
echo "${GREEN}[Create]$(get_time)${NC}: Files created and populated successfully. 🎉"
