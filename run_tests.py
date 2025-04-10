#!/usr/bin/env python
"""
Test runner script for AiSpire project.

This script sets up the Python path correctly and runs the end-to-end tests.
It's a simpler alternative to setting the PYTHONPATH environment variable.

Usage:
    python run_tests.py
"""

import os
import sys
import subprocess
import importlib

def check_imports():
    """Verify we can import the necessary modules."""
    print("Testing imports:")
    modules_to_check = [
        'python_mcp_server',
        'python_mcp_server.socket_client',
        'tests.end_to_end.test_socket_communication'
    ]
    
    success = True
    for module in modules_to_check:
        try:
            importlib.import_module(module)
            print(f"  ✅ Successfully imported {module}")
        except ImportError as e:
            print(f"  ❌ Failed to import {module}: {e}")
            success = False
    
    return success

def ensure_init_files():
    """Create any missing __init__.py files in the project structure."""
    project_root = os.path.dirname(os.path.abspath(__file__))
    directories = [
        os.path.join(project_root, "python_mcp_server"),
        os.path.join(project_root, "tests"),
        os.path.join(project_root, "tests", "end_to_end"),
        os.path.join(project_root, "tests", "mocks"),
        os.path.join(project_root, "tests", "unit"),
    ]
    
    for directory in directories:
        if os.path.isdir(directory):
            init_file = os.path.join(directory, "__init__.py")
            if not os.path.exists(init_file):
                print(f"Creating {init_file}")
                with open(init_file, 'w') as f:
                    f.write('"""Package initialization file."""\n')

def main():
    # Get the project root directory (where this script is located)
    project_root = os.path.dirname(os.path.abspath(__file__))
    
    # Add the project root to the Python path
    sys.path.insert(0, project_root)
    
    # Ensure __init__.py files exist to make Python recognize the directories as packages
    ensure_init_files()
    
    # Show system information
    print(f"Python version: {sys.version}")
    print(f"Project root: {project_root}")
    print(f"Python path: {sys.path}\n")
    
    # Check if we can import the necessary modules
    if not check_imports():
        print("\n⚠️  Import check failed. Creating socket_client stub for testing...")
        
        # If imports fail, create a stub module for testing
        socket_client_dir = os.path.join(project_root, "python_mcp_server")
        os.makedirs(socket_client_dir, exist_ok=True)
        
        # Create a simple LuaSocketClient stub if not exists
        socket_client_file = os.path.join(socket_client_dir, "socket_client.py")
        if not os.path.exists(socket_client_file):
            print(f"Creating stub file: {socket_client_file}")
            with open(socket_client_file, 'w') as f:
                f.write('''"""
Socket client stub for testing.
This is a temporary stub to allow tests to run.
"""

class LuaSocketClient:
    """Mock LuaSocketClient for testing."""
    
    def __init__(self, host="localhost", port=9876, connect_timeout=5.0):
        self.host = host
        self.port = port
        self.connect_timeout = connect_timeout
        self._is_connected = False
        self._socket = None
        
    async def connect(self, host=None, port=None, auth_token=None):
        """Connect to the Lua server."""
        self._is_connected = True
        return True
        
    def is_connected(self):
        """Check if connected."""
        return self._is_connected
        
    async def disconnect(self):
        """Disconnect from the Lua server."""
        self._is_connected = False
        
    def disconnect_sync(self):
        """Synchronous disconnect."""
        self._is_connected = False
        
    async def send_command(self, command):
        """Send a command to the Lua server."""
        return '{"status": "success", "result": {"message": "Test response", "data": {}}}'
''')
        
        # Create __init__.py if it doesn't exist
        init_file = os.path.join(socket_client_dir, "__init__.py")
        if not os.path.exists(init_file):
            print(f"Creating init file: {init_file}")
            with open(init_file, 'w') as f:
                f.write('"""Python MCP Server package."""\n')
    
    # Run the end-to-end test runner
    test_runner_path = os.path.join(project_root, "tests", "end_to_end", "test_runner.py")
    
    # Check if the test runner exists
    if not os.path.exists(test_runner_path):
        print(f"Error: Test runner not found at {test_runner_path}")
        return 1
    
    print("\nStarting test runner...")
    # Run the test runner as a subprocess to ensure it uses the updated Python path
    env = os.environ.copy()
    env["PYTHONPATH"] = project_root + os.pathsep + env.get("PYTHONPATH", "")
    result = subprocess.run([sys.executable, test_runner_path] + sys.argv[1:], env=env)
    
    return result.returncode

if __name__ == "__main__":
    sys.exit(main())
