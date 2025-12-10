.PHONY: help build run dev test lint build-docker run-docker push-docker clean docker-compose-up docker-compose-down

help:
	@echo "AI Quiz Generator - Docker & CI/CD Commands"
	@echo ""
	@echo "Local Development:"
	@echo "  make dev              - Run development server (npm)"
	@echo "  make build            - Build Next.js application"
	@echo "  make lint             - Run ESLint"
	@echo ""
	@echo "Docker Commands:"
	@echo "  make build-docker     - Build production Docker image"
	@echo "  make run-docker       - Run production Docker image"
	@echo "  make dev-docker       - Build development Docker image"
	@echo "  make run-dev-docker   - Run development Docker image"
	@echo ""
	@echo "Docker Compose:"
	@echo "  make docker-up        - Start services with docker-compose (dev)"
	@echo "  make docker-down      - Stop services with docker-compose"
	@echo ""
	@echo "Registry:"
	@echo "  make push-docker      - Push image to GitHub Container Registry"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean            - Remove node_modules and build artifacts"
	@echo "  make scan-vuln        - Scan Docker image for vulnerabilities"

# Local Development
dev:
	npm run dev

build:
	npm run build

lint:
	npm run lint

install:
	npm install

# Docker Build
build-docker:
	docker build -t ai-quiz-generator:latest --target production .

dev-docker:
	docker build -t ai-quiz-generator:dev --target development .

# Docker Run
run-docker: build-docker
	docker run -p 3000:3000 --env-file .env.local ai-quiz-generator:latest

run-dev-docker: dev-docker
	docker run -it -p 3000:3000 -v $(CURDIR):/app ai-quiz-generator:dev

# Docker Compose
docker-up:
	docker-compose up

docker-down:
	docker-compose down

# Registry
push-docker: build-docker
	@read -p "Enter GitHub username: " username; \
	docker tag ai-quiz-generator:latest ghcr.io/$$username/ai-quiz-generator:latest; \
	docker push ghcr.io/$$username/ai-quiz-generator:latest

# Security
scan-vuln: build-docker
	trivy image ai-quiz-generator:latest

# Cleanup
clean:
	rm -rf node_modules
	rm -rf .next
	rm -rf dist
	rm -rf coverage

.DEFAULT_GOAL := help
