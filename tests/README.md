# AiSpire Tests

This directory contains tests for the AiSpire project. The tests are organized into several categories:

## Unit Tests

- **Lua Tests**: Unit tests for the Lua Gadget component
- **Python Tests**: Unit tests for the Python MCP Server component

## End-to-End Tests

End-to-end tests verify the complete flow from the MCP Server through the Lua Gadget. These tests use a mock implementation of the Vectric SDK to avoid requiring the actual Vectric software.

### Installing Test Dependencies

Before running tests, install the required dependencies:

```bash
# From the project root directory
pip install -r test_requirements.txt
```

This will install all the necessary packages for both running the application and testing it.

### Running End-to-End Tests

To run the end-to-end tests:

1. Make sure you have all the required dependencies installed:
   ```bash
   pip install -r test_requirements.txt
   ```

2. Run the end-to-end test runner:
   ```bash
   python tests/end_to_end/test_runner.py
   ```

   This will:
   - Start a mock Lua server that simulates the Lua Gadget
   - Start the MCP server in test mode
   - Run all the end-to-end tests
   - Stop both servers when tests are complete

### End-to-End Test Categories

The end-to-end tests cover three main areas:

1. **Socket Communication Tests**: Verify that the MCP Server can establish and maintain a connection with the Lua Gadget, send commands, and receive responses.

2. **Command Execution Tests**: Verify that commands flow correctly from the MCP Server to the Lua Gadget and responses are properly handled.

3. **Error Handling Tests**: Verify that errors in the communication between the MCP Server and Lua Gadget are properly handled and the system can recover from them.

## Integration Tests

Integration tests verify the interaction between specific components without testing the entire system. These tests are located in the `tests/integration` directory.

## Manual Tests

Some tests require the actual Vectric software and cannot be automated. Instructions for manual testing are provided in the `tests/manual` directory.

## Mock Components

The `tests/mocks` directory contains mock implementations of external dependencies:

- `mock_lua_server.py`: A mock implementation of the Lua Gadget socket server
- `mock_vectric_sdk.py`: A mock implementation of the Vectric SDK

These mocks allow testing without requiring the actual Vectric software.

## Test Configuration

Test configuration can be modified in the `tests/config` directory.

## Adding New Tests

When adding new tests, follow these guidelines:

1. Place unit tests in the appropriate subdirectory based on the component being tested.
2. Place end-to-end tests in the `end_to_end` directory.
3. Follow the naming convention: `test_[feature_being_tested].py`
4. Include docstrings explaining the purpose of the test.
5. Update this README if adding a new category of tests.
