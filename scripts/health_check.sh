#!/bin/sh

# Define color codes (POSIX compliant ANSI escape codes)
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

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
    echo "[${BLUE}✅ health_check${NC}] (${endpoint} // $time) | ${GREEN}STATUS OK${NC} - HTTP Code: ${response}"
    echo "Response (formatted):"
    echo "$body" | jq .
  else
    echo "[${RED}❌ health_check${NC}] (${endpoint} // $time) | ${RED}STATUS FAIL${NC} - HTTP Code: ${response}"
    echo "Response (formatted):"
    echo "$body" | jq .
  fi

  # Clean up
  rm -f temp_response.txt
}

# Run health checks for the given endpoints
health_check "ps"
health_check "tags"
