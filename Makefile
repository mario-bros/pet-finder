# Makefile for Baja Pet Rescue Rails Development

.PHONY: help setup dev up start down stop console c test lint clean db-prepare db-migrate db-reset db-seed db-fixtures creds-edit creds-show

# Use a specific shell
SHELL := /bin/bash

# Default command, runs when you just type "make"
help:
	@echo "------------------------------------------------------------------"
	@echo " Baja Pet Rescue - Development Makefile"
	@echo "------------------------------------------------------------------"
	@echo " Commands:"
	@echo "   setup          : One-time setup (install gems, create DB, load fixtures)."
	@echo "   dev / up       : Start the development server and database."
	@echo "   down / stop    : Stop the development database container."
	@echo "   console / c    : Open the Rails console."
	@echo "   test           : Run the full test suite."
	@echo "   test-coverage  : Run tests and generate coverage report."
	@echo "   lint           : Run RuboCop to check code style."
	@echo "   clean          : Clear Rails logs and temporary files."
	@echo ""
	@echo " Database:"
	@echo "   db-prepare     : Create database and run migrations."
	@echo "   db-migrate     : Run pending database migrations."
	@echo "   db-reset       : Reset the database (drop, create, migrate, seed)."
	@echo "   db-fixtures    : Load fixtures from test/fixtures into development DB."
	@echo ""
	@echo " Credentials:"
	@echo "   creds-edit     : Edit development credentials (set EDITOR env var)."
	@echo "   creds-show     : Show development credentials."
	@echo "------------------------------------------------------------------"

## --------------------------------------------------------------------------
## Environment Setup
## --------------------------------------------------------------------------

# One-time setup for a new developer
setup:
	@echo "--- Setting up the development environment ---"
	@echo "--> Starting Postgres container..."
	@docker compose up -d db
	@echo "--> Installing gems..."
	@bundle install
	@echo "--> Preparing the database (create + migrate)..."
	@bin/rails db:prepare
	@echo "--> Loading admin user fixture..."
	@make db-fixtures
	@echo "--- Setup complete! Run 'make dev' to start the server. ---"

## --------------------------------------------------------------------------
## Daily Development
## --------------------------------------------------------------------------

# Start the development server and database
dev up start:
	@echo "--> Starting Rails server on http://localhost:3000 ..."
	@bin/rails server -e development -p 3001
	@bin/rails tailwindcss:watch

# Stop the database container
down stop:
	@echo "--> Stopping Postgres container..."
	@docker compose down -v

# Open the Rails console
console c:
	@bin/rails console

# Run the full test suite
test:
	@echo "--> Running all tests..."
	@bin/rails test:all

# Run tests and generate a coverage report
test-coverage:
	@echo "--> Running tests with coverage report..."
	@PARALLEL_WORKERS=1 COVERAGE=true bin/rails test:all

# Run the linter
lint:
	@echo "--> Running RuboCop linter..."
	@bundle exec rubocop

# Clear logs and tmp files
clean:
	@echo "--> Clearing logs and temporary files..."
	@bin/rails log:clear tmp:clear

## --------------------------------------------------------------------------
## Database Management
## --------------------------------------------------------------------------

db-prepare:
	@bin/rails db:prepare

db-migrate:
	@RAILS_ENV=development bin/rails db:migrate

db-reset:
	@bin/rails db:reset

db-seed:
	@bin/rails db:seed

db-fixtures:
	@echo "--> Loading fixtures from test/fixtures/..."
	@bin/rails db:fixtures:load FIXTURES_PATH=test/fixtures

## --------------------------------------------------------------------------
## Credentials Management
## --------------------------------------------------------------------------

# Example: EDITOR="code --wait" make creds-edit
creds-edit:
	@echo "--> Opening development credentials for editing..."
	@${EDITOR} bin/rails credentials:edit --environment development

creds-show:
	@echo "--> Showing development credentials..."
	@bin/rails credentials:show --environment development
