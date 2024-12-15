#!/bin/zsh

:'
This script is used on start up, to verify during usage, that the server is running.
For this, we use the /api/tags endpoint, which should always be available.

This endpoint, we use are the following:
- GET /api/ps => provides information on the models that are currently loaded into memory
- GET /api/tags => list of models available locally & tags

READ HERE: https://github.com/ollama/ollama/blob/main/docs/api.md
'

# Define color nodes

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function for time in european format
get_time(){
  date +"+%d-%m-%Y %H:%M:%S"
}

# Check given routes using curl
health_check(){
  # Define the endpoint
  local endpoint="$1"
  local url="http://localhost:11434/api/{$endpoint}"
  local response

  # Check the response
  response=$(curl --write-out "%{http_code}" --silent --output /dev/null "$url")
  local time
  time=$(get_time)

  # if response is 200, then we are good
  if [ "$response" -eq 200 ]; then
    echo -e "[{$GREEN}health_check{$NC}] (${endpoint} // $time) | ${GREEN}STATUS OK${NC} - HTTP Code: ${response}"
  else
    echo -e "[{$RED}health_check{$NC}] (${endpoint} // $time) | ${RED}STATUS FAIL${NC} - HTTP Code: ${response}"
  fi

  # Run health checks for the given endpoints
  health_check "tags"
  health_check "ps"
}


