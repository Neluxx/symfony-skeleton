# Makefile for Symfony Project
# Default shell: bash

# -------- Configuration --------
SYMFONY = bin/console
COMPOSER = ddev composer
PHPUNIT = vendor/bin/phpunit
PHPSTAN = vendor/bin/phpstan
CSFIXER = vendor/bin/php-cs-fixer

# -------- Default-Target --------
.PHONY: help
help:
	@echo "Available Targets:"
	@echo "  install      — Install composer dependencies"
	@echo "  update       — Update composer dependencies"
	@echo "  db-create    — Create database"
	@echo "  db-migrate   — Run migrations"
	@echo "  test         — Execute tests"
	@echo "  stan         — Static Analysis (PHPStan)"
	@echo "  cs-fix       — Code Style Fixer"
	@echo "  clear-cache  — Clear symfony cache"

# -------- Install & Update --------
.PHONY: install
install:
	$(COMPOSER) install --no-interaction --optimize-autoloader

.PHONY: update
update:
	$(COMPOSER) update --no-interaction

# -------- Database --------
.PHONY: db-create
db-create:
	$(SYMFONY) doctrine:database:create --if-not-exists

.PHONY: db-migrate
db-migrate:
	$(SYMFONY) doctrine:migrations:migrate --no-interaction

# -------- Testing & Quality --------
.PHONY: test
test:
	$(PHPUNIT) --colors=always

.PHONY: stan
stan:
	$(PHPSTAN) analyse src --level max

.PHONY: cs-fix
cs-fix:
	$(CSFIXER) fix src --using-cache=no

# -------- Cache & Logs --------
.PHONY: clear-cache
clear-cache:
	$(SYMFONY) cache:clear
