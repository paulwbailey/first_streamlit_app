.DEFAULT_GOAL := help

.ONESHELL:

SHELL = /bin/bash

.PHONY: help
help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: create-local-development-environment
create-local-environment: ## Creates a local conda environment using mamba and installs all requirements
	mamba env create -f environment.yml

.PHONY: install-production-packages
install-production-packages: ## Installs the packages required for production
	pip install --no-cache-dir --upgrade -r requirements.txt

.PHONY: install-development-packages
install-development-packages: ## Installs the packages required for development
	pip install --no-cache-dir --upgrade -r requirements-dev.txt

.PHONY: setup-pre-commit
setup-pre-commit: ## Sets up pre-commit including the configuration
	pre-commit install
	pre-commit gc
	pre-commit clean
	pre-commit autoupdate

.PHONY: update-pre-commit-revs
update-pre-commit-revs: ## Updates the rev versions in the .pre-commit-config.yaml to the latest stable version
	pre-commit autoupdate

.PHONY: check-code
check-code: ## Runs all pre-commit and pytest requirements
	pre-commit run --all-files
	pytest
