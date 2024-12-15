#!/bin/sh

# This script is used on start up, to verify during usage, that the server is running.
# For this, we use the given API endpoints from the documentation, which should always be available.

# Endpoints:
# - GET /api/ps  => provides information on the models that are currently loaded into memory
# - GET /api/tags => list of models available locally & tags

# Documentation: https://github.com/ollama/ollama/blob/main/docs/api.md

# Define color nodes using tput
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NC=$(tput sgr0) # No Color

# Base URL of the API
BASE_URL="http://localhost:11434"

# Function to format time in European format
get_time(){
  date +"%d-%m-%Y %H:%M:%S"
}

# Check given routes using curl
health_check(){
  # Define the endpoint
  endpoint="$1"
  url="${BASE_URL}/api/$endpoint"
  response=""
  time=$(get_time)

  # Check the response (capturing both body and status code)
  response=$(curl --write-out "%{http_code}" --silent --output temp_response.txt "$url")
  body=$(cat temp_response.txt)

  # Log health check status
  if [ "$response" -eq 200 ]; then
    printf "[%shealth_check%s] (%s // %s) | %sSTATUS OK%s - HTTP Code: %s\n" \
      "$GREEN" "$NC" "$endpoint" "$time" "$GREEN" "$NC" "$response"

    # Pretty format the JSON response using jq
    printf "Response (formatted):\n"
    echo "$body" | jq .
  else
    printf "[%shealth_check%s] (%s // %s) | %sSTATUS FAIL%s - HTTP Code: %s\n" \
      "$RED" "$NC" "$endpoint" "$time" "$RED" "$NC" "$response"

    # Print the body content of the response (pretty printed)
    printf "Response (formatted):\n"
    echo "$body" | jq .
  fi

  # Clean up
  rm -f temp_response.txt
}

# Run health checks for the given endpoints
health_check "ps"
health_check "tags"
