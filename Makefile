SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: generate-code
generate-code: ## Generate the otelcol code
	go get ./... && go mod tidy && go generate ./...

.PHONY: build
build: ## Build the otelcol image
	docker buildx build -t otelcol-dreamkast:latest .

.PHONY: lint
lint: lint-docker lint-gha lint-ocb ## Lint

.PHONY: lint-docker
lint-docker:
	hadolint Dockerfile

.PHONY: lint-gha
lint-gha:
	yamllint .github/workflows/
	actionlint
	ghalint run
	zizmor .

.PHONY: lint-ocb
lint-ocb:
	yamllint builder-config.yaml
