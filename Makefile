# AiSpire Project Makefile
# This makefile provides commands for testing and building the AiSpire project

# Directory variables
PROJECT_ROOT := $(shell pwd)
LUA_GADGET_DIR := $(PROJECT_ROOT)/lua_gadget
PYTHON_MCP_SERVER_DIR := $(PROJECT_ROOT)/python_mcp_server
TESTS_DIR := $(PROJECT_ROOT)/tests
VECTRIC_GADGETS_DIR := $(PROJECT_ROOT)/VectricGadgets

# Python variables
PYTHON := python
PIP := pip
PYTEST := pytest
PYTEST_ARGS := -v

# Lua variables
LUA := lua
BUSTED := busted
LUAROCKS := luarocks

# Set Python path for testing
export PYTHONPATH := $(PROJECT_ROOT):$(PYTHONPATH)

# Main targets
.PHONY: all test clean bundle install-dev-deps

all: test bundle

# Install development dependencies
install-dev-deps:
	@echo "Installing Python development dependencies..."
	$(PIP) install -r $(PROJECT_ROOT)/test_requirements.txt
	@echo "Installing Lua development dependencies..."
	$(LUAROCKS) install busted

# Testing targets
.PHONY: test test-all-lua test-all-python test-lua test-lua-helpers test-python-core test-python-mcp test-python-tests test-e2e

# Run all tests
test: test-all-lua test-all-python test-e2e
	@echo "All tests completed."

# Run all Lua tests
test-all-lua: test-lua test-lua-helpers
	@echo "All Lua tests completed."

# Run all Python tests
test-all-python: test-python-core test-python-mcp test-python-tests
	@echo "All Python tests completed."

# Run Lua tests
test-lua:
	@echo "Running Lua tests..."
	cd $(TESTS_DIR)/lua_tests && $(BUSTED) --helper=$(LUA_GADGET_DIR)/set_paths

# Run Lua helper tests
test-lua-helpers:
	@echo "Running Lua helper tests..."
	cd $(LUA_GADGET_DIR)/helpers/tests && $(BUSTED) --helper=$(LUA_GADGET_DIR)/set_paths

# Run Python core tests
test-python-core:
	@echo "Running Python core tests..."
	$(PYTEST) $(PYTEST_ARGS) $(TESTS_DIR)/python

# Run Python MCP server tests
test-python-mcp:
	@echo "Running Python MCP server tests..."
	$(PYTEST) $(PYTEST_ARGS) $(TESTS_DIR)/python_mcp_server
	$(PYTEST) $(PYTEST_ARGS) $(PYTHON_MCP_SERVER_DIR)/tests

# Run Python tests in tests/python_tests directory
test-python-tests:
	@echo "Running Python tests from tests/python_tests..."
	$(PYTEST) $(PYTEST_ARGS) $(TESTS_DIR)/python_tests

# Run end-to-end tests
test-e2e:
	@echo "Running end-to-end tests..."
	bash $(PROJECT_ROOT)/run_e2e_tests.sh

# Bundle the Vectric gadget
bundle:
	@echo "Creating Vectric gadget bundle..."
	@mkdir -p $(VECTRIC_GADGETS_DIR)
	@cd $(LUA_GADGET_DIR) && zip -r $(VECTRIC_GADGETS_DIR)/aispire.gadget * -x "*.git*" -x "*.DS_Store" -x "*.gitignore"
	@echo "Gadget bundle created at $(VECTRIC_GADGETS_DIR)/aispire.gadget"

# Run specific test suites
.PHONY: test-json test-socket-comm test-command-exec test-error-handling

test-json:
	@echo "Running JSON tests..."
	cd $(TESTS_DIR)/lua_tests && $(BUSTED) --helper=$(LUA_GADGET_DIR)/set_paths test_json.lua

test-socket-comm:
	@echo "Running socket communication tests..."
	$(PYTHON) $(TESTS_DIR)/end_to_end/test_socket_communication.py

test-command-exec:
	@echo "Running command execution tests..."
	$(PYTHON) $(TESTS_DIR)/end_to_end/test_command_execution.py

test-error-handling:
	@echo "Running error handling tests..."
	$(PYTHON) $(TESTS_DIR)/end_to_end/test_error_handling.py

# Clean up generated files
clean:
	@echo "Cleaning up..."
	@rm -rf $(VECTRIC_GADGETS_DIR)
	@find . -name "__pycache__" -type d -exec rm -rf {} +
	@find . -name "*.pyc" -delete
	@find . -name ".pytest_cache" -type d -exec rm -rf {} +
	@find . -name ".coverage" -delete
	@echo "Clean complete."

# Help target
.PHONY: help
help:
	@echo "AiSpire Project Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  all             - Run tests and create the gadget bundle (default)"
	@echo "  test            - Run all tests"
	@echo ""
	@echo "Test targets:"
	@echo "  test-all-lua    - Run all Lua tests"
	@echo "  test-all-python - Run all Python tests"
	@echo "  test-lua        - Run Lua tests in tests/lua_tests/"
	@echo "  test-lua-helpers - Run Lua helper tests in lua_gadget/helpers/tests/"
	@echo "  test-python-core - Run Python core tests"
	@echo "  test-python-mcp - Run Python MCP server tests"
	@echo "  test-python-tests - Run tests in tests/python_tests directory"
	@echo "  test-e2e        - Run end-to-end tests"
	@echo ""
	@echo "Specific test targets:"
	@echo "  test-json       - Run JSON tests"
	@echo "  test-socket-comm - Run socket communication tests"
	@echo "  test-command-exec - Run command execution tests"
	@echo "  test-error-handling - Run error handling tests"
	@echo ""
	@echo "Other targets:"
	@echo "  bundle          - Create the Vectric gadget bundle"
	@echo "  install-dev-deps - Install development dependencies"
	@echo "  clean           - Clean up generated files"
	@echo "  help            - Show this help message"