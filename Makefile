# Makefile for common operations
# Makefile

.PHONY: help install test lint build deploy rollback

help:
	@echo "Available targets:"
	@echo "  install      - Install dependencies"
	@echo "  test         - Run tests"
	@echo "  lint         - Run linters"
	@echo "  build        - Build Docker image"
	@echo "  deploy       - Deploy to Kubernetes"
	@echo "  rollback     - Rollback deployment"
	@echo "  security     - Run security scans"
	@echo "  clean        - Clean up resources"

install:
	cd app && npm ci

test:
	cd app && npm test

lint:
	cd app && npm run lint

build:
	docker build -t sample-microservice:latest ./app

deploy:
	./scripts/deploy.sh production

rollback:
	./scripts/rollback.sh production

security:
	./scripts/run-security-scans.sh

clean:
	./scripts/cleanup.sh production
