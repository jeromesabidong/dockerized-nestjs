# Makefile for Dockerized NestJS Application

# Variables
COMPOSE_FILE_DEV := docker-compose.dev.yml
COMPOSE_FILE_PROD := docker-compose.yml
APP_NAME := dockerized-nestjs
SERVICE_NAME := app

# Help command
.PHONY: help
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Development commands
.PHONY: dev-build
dev-build: ## Build the development Docker image
	docker-compose -f $(COMPOSE_FILE_DEV) build

.PHONY: dev-up
dev-up: ## Start the development environment
	docker-compose -f $(COMPOSE_FILE_DEV) up

.PHONY: dev-up-detached
dev-up-detached: ## Start the development environment in detached mode
	docker-compose -f $(COMPOSE_FILE_DEV) up -d

.PHONY: dev-down
dev-down: ## Stop the development environment
	docker-compose -f $(COMPOSE_FILE_DEV) down

.PHONY: dev-restart
dev-restart: ## Restart the development environment
	docker-compose -f $(COMPOSE_FILE_DEV) restart

.PHONY: dev-logs
dev-logs: ## Show development logs
	docker-compose -f $(COMPOSE_FILE_DEV) logs -f

.PHONY: dev-shell
dev-shell: ## Access shell in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) sh

# Production commands
.PHONY: prod-build
prod-build: ## Build the production Docker image
	docker-compose -f $(COMPOSE_FILE_PROD) build

.PHONY: prod-up
prod-up: ## Start the production environment
	docker-compose -f $(COMPOSE_FILE_PROD) up

.PHONY: prod-up-detached
prod-up-detached: ## Start the production environment in detached mode
	docker-compose -f $(COMPOSE_FILE_PROD) up -d

.PHONY: prod-down
prod-down: ## Stop the production environment
	docker-compose -f $(COMPOSE_FILE_PROD) down

.PHONY: prod-restart
prod-restart: ## Restart the production environment
	docker-compose -f $(COMPOSE_FILE_PROD) restart

.PHONY: prod-logs
prod-logs: ## Show production logs
	docker-compose -f $(COMPOSE_FILE_PROD) logs -f

.PHONY: prod-shell
prod-shell: ## Access shell in production container
	docker-compose -f $(COMPOSE_FILE_PROD) exec $(SERVICE_NAME) sh

# Testing commands
.PHONY: test
test: ## Run tests in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm test

.PHONY: test-e2e
test-e2e: ## Run e2e tests in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run test:e2e

.PHONY: test-watch
test-watch: ## Run tests in watch mode in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run test:watch

.PHONY: test-cov
test-cov: ## Run tests with coverage in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run test:cov

# Utility commands
.PHONY: clean
clean: ## Clean up containers, images, and volumes
	docker-compose -f $(COMPOSE_FILE_DEV) down -v --remove-orphans
	docker-compose -f $(COMPOSE_FILE_PROD) down -v --remove-orphans
	docker system prune -f

.PHONY: clean-all
clean-all: ## Clean up everything including images
	docker-compose -f $(COMPOSE_FILE_DEV) down -v --remove-orphans
	docker-compose -f $(COMPOSE_FILE_PROD) down -v --remove-orphans
	docker system prune -af

.PHONY: health
health: ## Check application health
	curl -f http://localhost:3000/api/health || echo "Application not responding"

.PHONY: install
install: ## Install dependencies in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm install

.PHONY: lint
lint: ## Run linter in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run lint

.PHONY: format
format: ## Format code in development container
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run format

# Build and run shortcuts
.PHONY: start
start: dev-build dev-up ## Build and start development environment

.PHONY: start-detached
start-detached: dev-build dev-up-detached ## Build and start development environment in detached mode

.PHONY: stop
stop: dev-down ## Stop development environment

.PHONY: restart
restart: dev-restart ## Restart development environment

.PHONY: rebuild
rebuild: dev-down dev-build dev-up ## Rebuild and restart development environment

# Database commands (when using PostgreSQL)
.PHONY: db-migrate
db-migrate: ## Run database migrations
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run migration:run

.PHONY: db-seed
db-seed: ## Seed the database
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run seed

.PHONY: db-reset
db-reset: ## Reset the database
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npm run migration:revert

# NestJS CLI commands
.PHONY: nest-info
nest-info: ## Show NestJS project information
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest info

.PHONY: nest-version
nest-version: ## Show NestJS CLI version
	docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest --version

.PHONY: nest-generate
nest-generate: ## Generate NestJS component (usage: make nest-generate COMPONENT=controller NAME=users)
	@if [ -z "$(COMPONENT)" ] || [ -z "$(NAME)" ]; then \
		echo "Usage: make nest-generate COMPONENT=<type> NAME=<name>"; \
		echo "Example: make nest-generate COMPONENT=controller NAME=users"; \
		echo "Available components: controller, service, module, guard, interceptor, pipe, filter, decorator, gateway, resolver, resource"; \
	else \
		docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest generate $(COMPONENT) $(NAME); \
	fi

.PHONY: nest-generate-controller
nest-generate-controller: ## Generate a controller (usage: make nest-generate-controller NAME=users)
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make nest-generate-controller NAME=<name>"; \
		echo "Example: make nest-generate-controller NAME=users"; \
	else \
		docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest generate controller $(NAME); \
	fi

.PHONY: nest-generate-service
nest-generate-service: ## Generate a service (usage: make nest-generate-service NAME=users)
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make nest-generate-service NAME=<name>"; \
		echo "Example: make nest-generate-service NAME=users"; \
	else \
		docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest generate service $(NAME); \
	fi

.PHONY: nest-generate-module
nest-generate-module: ## Generate a module (usage: make nest-generate-module NAME=users)
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make nest-generate-module NAME=<name>"; \
		echo "Example: make nest-generate-module NAME=users"; \
	else \
		docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest generate module $(NAME); \
	fi

.PHONY: nest-generate-resource
nest-generate-resource: ## Generate a complete CRUD resource (usage: make nest-generate-resource NAME=users)
	@if [ -z "$(NAME)" ]; then \
		echo "Usage: make nest-generate-resource NAME=<name>"; \
		echo "Example: make nest-generate-resource NAME=users"; \
	else \
		docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest generate resource $(NAME); \
	fi

.PHONY: nest-cli
nest-cli: ## Run custom NestJS CLI command (usage: make nest-cli CMD="generate controller users")
	@if [ -z "$(CMD)" ]; then \
		echo "Usage: make nest-cli CMD=\"<nest-command>\""; \
		echo "Example: make nest-cli CMD=\"generate controller users\""; \
		echo "Example: make nest-cli CMD=\"info\""; \
	else \
		docker-compose -f $(COMPOSE_FILE_DEV) exec $(SERVICE_NAME) npx nest $(CMD); \
	fi

# Default command
.DEFAULT_GOAL := help
