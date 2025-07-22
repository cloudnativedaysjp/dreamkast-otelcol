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
lint-docker: ## Docker に関連する事を検査する。事前に build を実行しておくこと
	hadolint Dockerfile
	yamllint compose.yaml container-structure-test.yaml
	container-structure-test test --image otelcol-dreamkast:latest --config container-structure-test.yaml

.PHONY: lint-gha
lint-gha:
	yamllint .github/workflows/
	actionlint
	ghalint run
	zizmor .

.PHONY: lint-ocb
lint-ocb:
	yamllint builder-config.yaml
