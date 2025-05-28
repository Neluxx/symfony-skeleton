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
	@echo "Development:"
	@echo "  app-setup    — Set up application"
	@echo "  git-update   — Update the git project"
	@echo "  update-dev   — Update dev environment"
	@echo ""
	@echo "Composer:"
	@echo "  install      — Install dependencies"
	@echo "  update       — Update dependencies"
	@echo "  selfupdate   — Self-update Composer"
	@echo ""
	@echo "Database:"
	@echo "  db-create    — Create local database"
	@echo "  db-drop      — Drop local database"
	@echo "  db-reset     — Reset local database"
	@echo ""
	@echo "Migrations:"
	@echo "  migrate      — Migrate new migrations"
	@echo "  rollback     — Rollback last migration"
	@echo "  reset        — Reset all migrations"
	@echo ""
	@echo "Testing:"
	@echo "  test         — Execute tests"
	@echo "  stan         — Static Analysis (PHPStan)"
	@echo "  cs-fix       — Code Style Fixer"
	@echo ""
	@echo "Cache:"
	@echo "  clear-cache  — Clear all caches"

# -------- Development --------
.PHONY: app-setup
app-setup:
	$(MAKE) selfupdate
	$(MAKE) install
	$(MAKE) db-reset
	$(MAKE) migrate
	$(MAKE) test

.PHONY: git-update
git-update:
	git pull

.PHONY: update-dev
update-dev:
	$(MAKE) git-update
	$(MAKE) selfupdate
	$(MAKE) install
	$(MAKE) migrate
	$(MAKE) test

# -------- Composer --------
.PHONY: install
install:
	$(COMPOSER) -V
	$(COMPOSER) install --optimize-autoloader

.PHONY: update
update:
	$(COMPOSER) update

.PHONY: selfupdate
selfupdate:
	$(COMPOSER) selfupdate --2

# -------- Database --------
.PHONY: db-create
db-create:
	$(SYMFONY) doctrine:database:create --if-not-exists

.PHONY: db-drop
db-drop:
	$(SYMFONY) doctrine:database:drop --if-exists

.PHONY: db-reset
db-reset:
	$(MAKE) db-drop
	$(MAKE) db-create

# -------- Migrations --------
.PHONY: migrate
migrate:
	$(SYMFONY) doctrine:migrations:migrate

.PHONY: rollback
rollback:
	$(SYMFONY) doctrine:migrations:migrate prev

.PHONY: reset
reset:
	$(SYMFONY) doctrine:migrations:migrate 0

# -------- Testing --------
.PHONY: test
test:
	$(PHPUNIT) --colors=always

.PHONY: stan
stan:
	$(PHPSTAN) analyse src

.PHONY: cs-fix
cs-fix:
	$(CSFIXER) fix src --using-cache=no

# -------- Cache --------
.PHONY: clear-cache
clear-cache:
	$(SYMFONY) cache:clear
	$(SYMFONY) cache:warmup
