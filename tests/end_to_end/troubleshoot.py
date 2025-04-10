"""
Troubleshooting script for end-to-end tests.

This script checks common issues that might prevent end-to-end tests from running correctly.
Run this script to diagnose problems before running the actual tests.

Usage: 
    python tests/end_to_end/troubleshoot.py
"""

import os
import sys
import socket
import importlib
import subprocess
import platform

def print_header(message):
    """Print a header message."""
    print("\n" + "=" * 80)
    print(f" {message}")
    print("=" * 80)

def check_python_version():
    """Check if Python version is compatible."""
    print_header("Checking Python Version")
    version = sys.version_info
    print(f"Python version: {platform.python_version()}")
    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("❌ ERROR: Python 3.8+ is required")
        return False
    else:
        print("✅ Python version is compatible")
        return True

def check_dependencies():
    """Check if required dependencies are installed."""
    print_header("Checking Dependencies")
    required_packages = [
        'pytest', 'pytest-asyncio', 'aiohttp', 'websockets', 
        'ujson', 'structlog', 'python-dotenv'
    ]
    
    missing_packages = []
    for package in required_packages:
        try:
            importlib.import_module(package)
            print(f"✅ {package} is installed")
        except ImportError:
            print(f"❌ {package} is missing")
            missing_packages.append(package)
    
    if missing_packages:
        print("\n⚠️  Missing dependencies detected!")
        print("Run: pip install -r test_requirements.txt")
        return False
    return True

def check_ports():
    """Check if required ports are available."""
    print_header("Checking Required Ports")
    ports_to_check = [9876, 8765]  # Mock Lua server and MCP server ports
    
    for port in ports_to_check:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex(('localhost', port))
        if result == 0:
            print(f"❌ Port {port} is already in use")
            sock.close()
            return False
        else:
            print(f"✅ Port {port} is available")
        sock.close()
    return True

def check_project_structure():
    """Check if project structure is correct."""
    print_header("Checking Project Structure")
    
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
    
    required_directories = [
        'python_mcp_server',
        'lua_gadget',
        'tests',
        'tests/mocks',
        'tests/end_to_end'
    ]
    
    required_files = [
        'tests/end_to_end/test_runner.py',
        'tests/end_to_end/test_socket_communication.py',
        'tests/end_to_end/test_command_execution.py',
        'tests/end_to_end/test_error_handling.py',
        'tests/mocks/mock_lua_server.py',
        'tests/mocks/mock_vectric_sdk.py'
    ]
    
    for directory in required_directories:
        dir_path = os.path.join(project_root, directory)
        if os.path.isdir(dir_path):
            print(f"✅ Directory exists: {directory}")
        else:
            print(f"❌ Missing directory: {directory}")
            return False
    
    for file in required_files:
        file_path = os.path.join(project_root, file)
        if os.path.isfile(file_path):
            print(f"✅ File exists: {file}")
        else:
            print(f"❌ Missing file: {file}")
            return False
    
    return True

def check_python_path():
    """Check if Python path is set correctly."""
    print_header("Checking Python Path")
    
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../..'))
    
    if project_root in sys.path:
        print(f"✅ Project root is in Python path: {project_root}")
    else:
        print(f"❌ Project root is NOT in Python path: {project_root}")
        print("This may cause import errors. Try running tests with:")
        print(f"PYTHONPATH={project_root} python tests/end_to_end/test_runner.py")
        return False
    
    return True

def check_permission_errors():
    """Check if there are permission errors when creating processes."""
    print_header("Checking Permissions")
    
    try:
        # Try to create a subprocess
        proc = subprocess.Popen(
            ['python', '-c', 'print("Permission test")'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        stdout, stderr = proc.communicate(timeout=2)
        
        if proc.returncode == 0:
            print("✅ Process creation works correctly")
            return True
        else:
            print(f"❌ Error creating process: {stderr.strip()}")
            return False
    except Exception as e:
        print(f"❌ Exception when creating process: {str(e)}")
        return False

def main():
    """Main function to run all checks."""
    print_header("End-to-End Test Troubleshooting")
    
    checks = [
        check_python_version,
        check_dependencies,
        check_ports,
        check_project_structure,
        check_python_path,
        check_permission_errors
    ]
    
    all_passed = True
    for check in checks:
        if not check():
            all_passed = False
    
    print_header("Troubleshooting Summary")
    if all_passed:
        print("✅ All checks passed! Try running the tests with:")
        print("python tests/end_to_end/test_runner.py")
    else:
        print("⚠️  Some checks failed. Please fix the issues above before running tests.")
        print("For more help, check the documentation at tests/README.md")
    
    return 0 if all_passed else 1

if __name__ == "__main__":
    sys.exit(main())
