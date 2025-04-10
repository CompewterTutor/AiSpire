#!/bin/bash

# Script to run end-to-end tests with proper environment setup
# Usage: ./run_e2e_tests.sh

# Get the project root directory
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set Python path
export PYTHONPATH="$PROJECT_ROOT:$PYTHONPATH"

# Check for required directories and files
if [ ! -d "$PROJECT_ROOT/tests/end_to_end" ]; then
    echo "Error: end_to_end test directory not found!"
    exit 1
fi

if [ ! -f "$PROJECT_ROOT/tests/end_to_end/test_runner.py" ]; then
    echo "Error: test_runner.py not found!"
    exit 1
fi

# Check if test requirements are installed
echo "Checking for required dependencies..."
python -c "import pytest, pytest_asyncio, aiohttp" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Installing test dependencies..."
    pip install -r "$PROJECT_ROOT/test_requirements.txt"
fi

# Run the troubleshooting script first
echo "Running troubleshooting checks..."
python "$PROJECT_ROOT/tests/end_to_end/troubleshoot.py"
if [ $? -ne 0 ]; then
    echo "Troubleshooting found issues. Please fix them before running tests."
    exit 1
fi

# Run the tests
echo "Running end-to-end tests..."
python "$PROJECT_ROOT/tests/end_to_end/test_runner.py" "$@"
