# Build configuration
# -------------------

GIT_REVISION = `git rev-parse HEAD`
DOCKER_REGISTRY ?=
DOCKER_LOCAL_IMAGE = killswitch:$(GIT_REVISION)
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
	@printf "\033[33m%-23s\033[0m" "GIT_REVISION"
	@printf "\033[35m%s\033[0m" $(GIT_REVISION)
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
