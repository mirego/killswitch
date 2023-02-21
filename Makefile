# Build configuration
# -------------------

DOCKER_TAG ?= `git rev-parse HEAD`
DOCKER_REGISTRY = ghcr.io
DOCKER_LOCAL_IMAGE = mirego/killswitch:$(DOCKER_TAG)
DOCKER_REMOTE_IMAGE = $(DOCKER_REGISTRY)/$(DOCKER_LOCAL_IMAGE)

# Linter and formatter configuration
# ----------------------------------

PRETTIER_FILES_PATTERN = '*.config.js' '**/*.{js,es6}' './*.md' './*/*.md'
SCRIPTS_PATTERN = '**/*.es6' '**/*.js'
STYLES_PATTERN = '**/*.scss' '**/*.css'

# Introspection targets
# ---------------------

.PHONY: help
help: header targets

.PHONY: header
header:
	@echo "\033[34mEnvironment\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@printf "\033[33m%-23s\033[0m" "DOCKER_TAG"
	@printf "\033[35m%s\033[0m" $(DOCKER_TAG)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "DOCKER_REGISTRY"
	@printf "\033[35m%s\033[0m" $(DOCKER_REGISTRY)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "DOCKER_LOCAL_IMAGE"
	@printf "\033[35m%s\033[0m" $(DOCKER_LOCAL_IMAGE)
	@echo ""
	@printf "\033[33m%-23s\033[0m" "DOCKER_REMOTE_IMAGE"
	@printf "\033[35m%s\033[0m" $(DOCKER_REMOTE_IMAGE)
	@echo "\n"

.PHONY: targets
targets:
	@echo "\033[34mTargets\033[0m"
	@echo "\033[34m---------------------------------------------------------------\033[0m"
	@perl -nle'print $& if m{^[a-zA-Z_-\d]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

# Build targets
# -------------

.PHONY: build
build: ## Build the Docker image for the OTP release
	docker build --rm --tag $(DOCKER_LOCAL_IMAGE) .

.PHONY: push
push: ## Push the Docker image to the registry
	docker tag $(DOCKER_LOCAL_IMAGE) $(DOCKER_REMOTE_IMAGE)
	docker push $(DOCKER_REMOTE_IMAGE)

# Development targets
# -------------------

.PHONY: dependencies
dependencies:
	bundle install
	npm install

.PHONY: test
test:
	RAILS_ENV=test bundle exec rails db:environment:set
	RAILS_ENV=test bundle exec rake db:schema:load
	RAILS_ENV=test bundle exec rspec

.PHONY: setup-development
setup-development:
	RAILS_ENV=development bundle exec rails db:environment:set
	RAILS_ENV=development bundle exec rake db:schema:load
	KILLSWITCH_SAMPLE_DATA_EMAIL=foo@example.com KILLSWITCH_SAMPLE_DATA_PASSWORD=p@ssw0rd bundle exec rake sample_data:create

# Check, lint and format targets
# ------------------------------

.PHONY: format
format: ## Format project files
	npx prettier --write $(PRETTIER_FILES_PATTERN)
	npx eslint $(SCRIPTS_PATTERN) --fix --quiet
	npx stylelint $(STYLES_PATTERN) --fix --quiet

.PHONY: lint
lint: lint-format lint-ruby lint-scripts lint-styles ## Lint project files

.PHONY: lint-format
lint-format:
	npx prettier --check $(PRETTIER_FILES_PATTERN)

.PHONY: lint-ruby
lint-ruby:
	bundle exec rubocop

.PHONY: lint-scripts
lint-scripts:
	npx eslint $(SCRIPTS_PATTERN)

.PHONY: lint-styles
lint-styles:
	npx stylelint $(STYLES_PATTERN)

.PHONY: check
check: check-dependencies-security check-code-security

.PHONY: check-dependencies-security
check-dependencies-security:
	bundle exec bundle-audit check --update
	npm audit --production

.PHONY: check-code-security
check-code-security:
	bundle exec brakeman

.PHONY: check-container-security
check-container-security:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --no-progress --skip-dirs vendor,node_modules $(DOCKER_LOCAL_IMAGE)

.PHONY: check-configuration-security
check-configuration-security:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path aquasec/trivy config --format table /path
#	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path checkmarx/kics scan -p /path --no-progress --no-color -v --log-level DEBUG --exclude-paths '/path/node_modules,/path/config,/path/.github,/path/docker-compose.yml,/path/.vagrant'

.PHONY: check-security
check-security:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path aquasec/trivy fs --no-progress --format table --skip-dirs node_modules,.vagrant /path
#	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path anchore/grype:latest dir:/path --scope all-layers -o table
	# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path anchore/grype:latest sbom:/path/sbom.spdx.json -o table

.PHONY: generate-sbom
generate-sbom:
#	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path anchore/syft:latest packages dir:/path --scope all-layers -o spdx-json=/path/sbom.spdx.json
#	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path anchore/syft:latest docker:$(DOCKER_LOCAL_IMAGE) --scope all-layers -o cyclonedx-json=/path/sbom.cdx.json
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path anchore/syft:latest docker:$(DOCKER_LOCAL_IMAGE) --scope all-layers -o table

.PHONY: check-container-content
check-container-content:
#	container-structure-test test --verbosity debug --image $(DOCKER_LOCAL_IMAGE) --config cst-config.yaml
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock gcr.io/gcp-runtimes/container-structure-test:latest test --verbosity debug --image $(DOCKER_LOCAL_IMAGE) --config cst-config.yaml

.PHONY: inspect-image
inspect-image:
	docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest $(DOCKER_LOCAL_IMAGE)

.PHONY: list-container-content
list-container-content:
	docker create --name killswitch-container $(DOCKER_LOCAL_IMAGE)
	docker export killswitch-container | tar t > files.txt

.PHONY: sign-container
sign-container:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $$(pwd):/path anchore/syft:latest attest --key /path/cosign.key -o cyclonedx-json $(DOCKER_LOCAL_IMAGE) > /path/sbom_att.json

.PHONY: clear-security
clear-security:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --clear-cache
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy config --clear-cache
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy fs --clear-cache
