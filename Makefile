# Makefile for managing Docker Compose commands

# Variables
COMPOSE=@docker compose
IMAGE=plant-assistant:latest
SERVICE=plant-assistant

.PHONY: all build up upb up-no-cache down logs logs-follow build-no-cache restart clean

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
	$(COMPOSE) up --build

# Bring up the services without using cache
up-no-cache:
	@echo "Bringing up services without using cache..."
	$(COMPOSE) up --build --no-cache

# Bring up the services in detached mode
up:
	@echo "Bringing up services..."
	$(COMPOSE) up -d

enter:
	@echo "Entering the container..."
	$(COMPOSE) exec $(SERVICE) bash

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
	@echo "  build           Build the Docker images."
	@echo "  build-no-cache  Build the Docker images without using cache."
	@echo "  up              Bring up the services in detached mode."
	@echo "  upb             Bring up the services with build."
	@echo "  up-no-cache     Bring up the services without using cache."
	@echo "  restart         Restart the services."
	@echo "  down            Bring down the services."
	@echo "  logs            View logs for all services."
	@echo "  logs-follow     Follow logs with timestamps."
	@echo "  clean           Remove containers, images, volumes, and orphans."
	@echo "  help            Show this help message."
