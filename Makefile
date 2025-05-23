SHELL=/bin/bash

.PHONY: help
help:
	@awk -F':.*##' '/^[-_a-zA-Z0-9]+:.*##/{printf"%-12s\t%s\n",$$1,$$2}' $(MAKEFILE_LIST) | sort

.PHONY: generate-code
generate-code: ## Generate the otelcol code
	docker buildx build -t otelcol-dreamkast:ocb --target ocb .
	docker run --rm --mount type=bind,source=$(PWD),target=/mnt --workdir /mnt otelcol-dreamkast:ocb ocb --config builder-config.yaml --skip-compilation

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
	ghalint run || true
	zizmor . || true

.PHONY: lint-ocb
lint-ocb:
	yamllint builder-config.yaml
