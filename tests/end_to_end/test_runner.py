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
import importlib
import logging
import asyncio
import subprocess
from concurrent.futures import ThreadPoolExecutor

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('test_runner')

# Add project root to Python path for imports
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
if project_root not in sys.path:
    sys.path.insert(0, project_root)
    logger.info(f"Added project root to Python path: {project_root}")

# Check if we can import required modules
def check_imports():
    """Check if we can import all required modules."""
    required_modules = [
        'python_mcp_server.socket_client',
        'tests.end_to_end.test_socket_communication',
        'tests.end_to_end.test_command_execution',
        'tests.end_to_end.test_error_handling'
    ]
    
    all_success = True
    for module_name in required_modules:
        try:
            importlib.import_module(module_name)
            logger.info(f"Successfully imported {module_name}")
        except ImportError as e:
            all_success = False
            logger.error(f"Failed to import {module_name}: {e}")
    
    return all_success

# If imports check fails, exit with error
if not check_imports():
    logger.error("Import checks failed. Please check your Python path and module installations.")
    logger.error("Try running the tests with: python run_tests.py")
    sys.exit(1)

# Import test modules
from tests.end_to_end.test_socket_communication import SocketCommunicationTests
from tests.end_to_end.test_command_execution import CommandExecutionTests
from tests.end_to_end.test_error_handling import ErrorHandlingTests

# Global variables for processes
lua_mock_process = None
mcp_server_process = None

def start_lua_mock_server():
    """Start the mock Lua socket server."""
    logger.info("Starting mock Lua server...")
    
    # Check if the mock server script exists
    mock_script_path = os.path.join(project_root, 'tests', 'mocks', 'mock_lua_server.py')
    if not os.path.exists(mock_script_path):
        logger.error(f"Mock Lua server script not found at {mock_script_path}")
        return None
    
    # Start the mock Lua server
    env = os.environ.copy()
    env["PYTHONPATH"] = project_root + os.pathsep + env.get("PYTHONPATH", "")
    
    process = subprocess.Popen(
        [sys.executable, mock_script_path],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env=env
    )
    
    # Give it time to start
    time.sleep(1)
    
    # Check if the process is still running
    if process.poll() is not None:
        stdout, stderr = process.communicate()
        logger.error(f"Mock Lua server failed to start: {stderr}")
        return None
    
    return process

def start_mcp_server():
    """Start the MCP server."""
    logger.info("Starting MCP server...")
    
    # Check if the MCP server script exists
    server_script_path = os.path.join(project_root, 'python_mcp_server', 'run_server.py')
    if not os.path.exists(server_script_path):
        logger.warning(f"MCP server script not found at {server_script_path}")
        logger.info("Skipping MCP server start - mock tests will still run")
        return None
    
    # Start the MCP server in test mode
    env = os.environ.copy()
    env["PYTHONPATH"] = project_root + os.pathsep + env.get("PYTHONPATH", "")
    
    process = subprocess.Popen(
        [sys.executable, server_script_path, "--test-mode"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        env=env
    )
    
    # Give it time to start
    time.sleep(2)
    
    # Check if the process is still running
    if process.poll() is not None:
        stdout, stderr = process.communicate()
        logger.error(f"MCP server failed to start: {stderr}")
        return None
    
    return process

def stop_servers():
    """Stop the servers."""
    global lua_mock_process, mcp_server_process
    
    if lua_mock_process:
        logger.info("Stopping mock Lua server...")
        lua_mock_process.terminate()
        try:
            lua_mock_process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            lua_mock_process.kill()
        
    if mcp_server_process:
        logger.info("Stopping MCP server...")
        mcp_server_process.terminate()
        try:
            mcp_server_process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            mcp_server_process.kill()

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
        # Print system info
        logger.info(f"Python version: {sys.version}")
        logger.info(f"Project root: {project_root}")
        logger.info(f"Python path: {sys.path}")
        
        # Start the mock servers
        lua_mock_process = start_lua_mock_server()
        if not lua_mock_process:
            logger.error("Failed to start mock Lua server. Tests may fail.")
        
        mcp_server_process = start_mcp_server()
        # It's ok if MCP server doesn't start - we'll still run tests
        
        # Run the tests
        result = run_tests()
        
        # Stop the servers
        stop_servers()
        
        # Exit with appropriate status code
        if result.wasSuccessful():
            logger.info("All end-to-end tests passed!")
            return 0
        else:
            logger.error("Some tests failed!")
            return 1
            
    except KeyboardInterrupt:
        logger.info("Test runner interrupted.")
        stop_servers()
        return 2
    except Exception as e:
        logger.error(f"Error running tests: {e}", exc_info=True)
        stop_servers()
        return 3

if __name__ == "__main__":
    sys.exit(main())
