# Makefile for managing Docker Compose commands and Ollama operations

# Variables
COMPOSE=@docker compose
SERVICE=ollama

.PHONY: all build up upb up-no-cache down logs logs-time build-no-cache restart clean enter help start wait-for-health

# Default target
all: help

# Build the Docker image
build:
	@echo "Building the Docker image..."
	$(COMPOSE) build

# Build without cache
build-no-cache:
	@echo "Building the Docker image without cache..."
	$(COMPOSE) build --no-cache

# Bring up the services with build
upb:
	@echo "Bringing up services with build..."
	$(COMPOSE) up --build -d

# Bring up the services without using cache
up-no-cache:
	@echo "Bringing up services without using cache..."
	$(COMPOSE) up --build --no-cache

# Bring up the services in detached mode
up:
	@echo "Bringing up services..."
	$(COMPOSE) up

# Start the services and wait for health check
start: up wait-for-health
	@echo "Services are up and healthy."

wait-for-health:
	@echo "Waiting for the Ollama service to be healthy..."
	@until [ "$$($(COMPOSE) ps --services --filter "health=healthy" | grep -w $(SERVICE))" = "$(SERVICE)" ]; do \
		sleep 5; \
		echo "Still waiting..."; \
	done
	@echo "Ollama service is up and running!"


# Enter the container's shell
enter:
	@echo "Entering the container..."
	$(COMPOSE) exec $(SERVICE) sh

# Restart the services
restart:
	@echo "Restarting services..."
	$(COMPOSE) restart

# Bring down the services
down:
	@echo "Bringing down services..."
	$(COMPOSE) down

# View logs for all services
logs:
	@echo "Fetching logs for all services..."
	$(COMPOSE) logs -f

# Follow logs for all services with timestamps
logs-time:
	@echo "Following logs with timestamps..."
	$(COMPOSE) logs -f -t

# Clean up Docker images and containers
clean:
	@echo "Cleaning up Docker containers and images..."
	$(COMPOSE) down --rmi all -v --remove-orphans

# Help command to display available targets
help:
	@echo "Available Makefile targets:"
	@echo "  build             Build the Docker images."
	@echo "  build-no-cache    Build the Docker images without using cache."
	@echo "  up                Bring up the services in detached mode."
	@echo "  upb               Bring up the services with build."
	@echo "  up-no-cache       Bring up the services without using cache."
	@echo "  start             Start the services and wait for them to become healthy."
	@echo "  restart           Restart the services."
	@echo "  down              Bring down the services."
	@echo "  logs              View logs for all services."
	@echo "  logs-time         Follow logs with timestamps."
	@echo "  clean             Remove containers, images, volumes, and orphans."
	@echo "  enter             Enter the container's shell."
	@echo "  help              Show this help message."
