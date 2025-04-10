"""
End-to-End Test Runner for AiSpire

This script runs all the end-to-end tests for the AiSpire project.
It launches the mock Lua server, the MCP server, and runs integration tests.

Usage:
    python test_runner.py

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import os
import sys
import time
import unittest
import asyncio
import subprocess
from concurrent.futures import ThreadPoolExecutor

# Add project root to Python path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

# Import test modules
from tests.end_to_end.test_socket_communication import SocketCommunicationTests
from tests.end_to_end.test_command_execution import CommandExecutionTests
from tests.end_to_end.test_error_handling import ErrorHandlingTests

# Global variables for processes
lua_mock_process = None
mcp_server_process = None

def start_lua_mock_server():
    """Start the mock Lua socket server."""
    print("Starting mock Lua server...")
    # Change to the mock server directory
    os.chdir(os.path.join(os.path.dirname(__file__), '../mocks'))
    # Start the mock Lua server
    process = subprocess.Popen(
        ['python', 'mock_lua_server.py'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    # Give it time to start
    time.sleep(1)
    return process

def start_mcp_server():
    """Start the MCP server."""
    print("Starting MCP server...")
    # Change to the project root
    os.chdir(os.path.join(os.path.dirname(__file__), '../..'))
    # Start the MCP server in test mode
    process = subprocess.Popen(
        ['python', '-m', 'python_mcp_server.run_server', '--test-mode'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    # Give it time to start
    time.sleep(2)
    return process

def stop_servers():
    """Stop the servers."""
    global lua_mock_process, mcp_server_process
    
    if lua_mock_process:
        print("Stopping mock Lua server...")
        lua_mock_process.terminate()
        lua_mock_process.wait()
        
    if mcp_server_process:
        print("Stopping MCP server...")
        mcp_server_process.terminate()
        mcp_server_process.wait()

def run_tests():
    """Run all end-to-end tests."""
    # Create the test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()
    
    # Add test cases to the suite
    suite.addTests(loader.loadTestsFromTestCase(SocketCommunicationTests))
    suite.addTests(loader.loadTestsFromTestCase(CommandExecutionTests))
    suite.addTests(loader.loadTestsFromTestCase(ErrorHandlingTests))
    
    # Run the tests
    runner = unittest.TextTestRunner(verbosity=2)
    return runner.run(suite)

def main():
    """Main entry point."""
    global lua_mock_process, mcp_server_process
    
    try:
        # Start the mock servers
        lua_mock_process = start_lua_mock_server()
        mcp_server_process = start_mcp_server()
        
        # Run the tests
        result = run_tests()
        
        # Stop the servers
        stop_servers()
        
        # Exit with appropriate status code
        if result.wasSuccessful():
            print("All end-to-end tests passed!")
            return 0
        else:
            print("Some tests failed!")
            return 1
            
    except KeyboardInterrupt:
        print("Test runner interrupted.")
        stop_servers()
        return 2
    except Exception as e:
        print(f"Error running tests: {e}")
        stop_servers()
        return 3

if __name__ == "__main__":
    sys.exit(main())
