# Minimal Makefile for Docker Compose dev environment

COMPOSE_FILE := ops/compose/docker-compose.dev.yml
PROJECT_NAME := $(notdir $(CURDIR))
DOCKER_COMPOSE := docker compose -p $(PROJECT_NAME) -f $(COMPOSE_FILE) --profile dev

EXEC_PHP := $(DOCKER_COMPOSE) exec api-php
EXEC_FE := $(DOCKER_COMPOSE) exec ui-node

.DEFAULT_GOAL := help

prepare: ## Create empty app folders
	mkdir -p apps/api apps/frontend

start: prepare ## Start containers
	$(DOCKER_COMPOSE) up -d

stop: ## Stop containers
	$(DOCKER_COMPOSE) down

restart: ## Restart containers
	$(MAKE) stop
	$(MAKE) start

build: prepare ## Build all containers without starting them
	$(DOCKER_COMPOSE) build

rebuild: prepare ## Rebuild and restart containers
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d --build

bash: ## Enter the api-php container with bash
	$(EXEC_PHP) bash

fe-bash: ## Enter the frontend ui-node container with bash
	$(EXEC_FE) bash

install-symfony: prepare ## Install latest Symfony skeleton into apps/api
	@if [ "$$(ls -A apps/api 2>/dev/null)" ]; then \
		echo "apps/api is not empty. Aborting."; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) up -d api-php
	$(EXEC_PHP) composer create-project symfony/skeleton .

install-symfony-lts: prepare ## Install Symfony LTS skeleton into apps/api
	@if [ "$$(ls -A apps/api 2>/dev/null)" ]; then \
		echo "apps/api is not empty. Aborting."; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) up -d api-php
	$(EXEC_PHP) composer create-project symfony/skeleton:"7.4.*" .

install-symfony-webapp: install-symfony ## Install Symfony webapp pack after skeleton
	$(EXEC_PHP) composer require webapp

install-angular: prepare ## Install Angular app into apps/frontend
	@if [ "$$(ls -A apps/frontend 2>/dev/null)" ]; then \
		echo "apps/frontend is not empty. Aborting."; \
		exit 1; \
	fi
	$(DOCKER_COMPOSE) up -d ui-node
	$(EXEC_FE) npx -y @angular/cli@latest new . --directory . --skip-git --routing --style scss

angular-serve: ## Start Angular dev server
	$(EXEC_FE) npx ng serve --host 0.0.0.0 --port 3000

phpstan: ## Run PHPStan analysis
	$(EXEC_PHP) vendor/bin/phpstan analyse

rector: ## Run Rector dry-run
	$(EXEC_PHP) vendor/bin/rector process --dry-run

rector-fix: ## Run Rector and apply changes
	$(EXEC_PHP) vendor/bin/rector process

cs-fix: ## Run PHP-CS-Fixer dry-run
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix --dry-run --diff

cs-fix-apply: ## Run PHP-CS-Fixer and apply fixes
	$(EXEC_PHP) vendor/bin/php-cs-fixer fix

qa: ## Run all quality tools
	$(MAKE) phpstan
	$(MAKE) rector
	$(MAKE) cs-fix

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'
