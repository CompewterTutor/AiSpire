"""
Mock Lua Socket Server for testing

This module simulates the Lua Gadget socket server for end-to-end testing.
It responds to commands in the same format as the real Lua Gadget.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import json
import socket
import logging
import threading
import time
import sys
import os

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger('mock_lua_server')

# Add project root to Python path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

# Import vectric SDK mock
from tests.mocks.mock_vectric_sdk import MockVectricSDK

class MockLuaServer:
    """Mock server that simulates the Lua Gadget for testing purposes."""
    
    def __init__(self, host='localhost', port=9876):
        self.host = host
        self.port = port
        self.server_socket = None
        self.running = False
        self.connections = []
        self.sdk = MockVectricSDK()
        self.auth_token = "test_auth_token"
        
    def start(self):
        """Start the mock server."""
        try:
            self.server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.server_socket.bind((self.host, self.port))
            self.server_socket.listen(5)
            self.running = True
            
            logger.info(f"Mock Lua server started on {self.host}:{self.port}")
            
            # Accept connections in a loop
            while self.running:
                try:
                    client_socket, client_address = self.server_socket.accept()
                    logger.info(f"Connection accepted from {client_address}")
                    
                    # Handle client in a new thread
                    client_thread = threading.Thread(
                        target=self.handle_client,
                        args=(client_socket, client_address)
                    )
                    client_thread.daemon = True
                    client_thread.start()
                    self.connections.append((client_socket, client_thread))
                    
                except socket.timeout:
                    continue
                except Exception as e:
                    if self.running:
                        logger.error(f"Error accepting connection: {e}")
                    break
                    
        except Exception as e:
            logger.error(f"Error starting server: {e}")
            self.stop()
    
    def stop(self):
        """Stop the mock server."""
        self.running = False
        
        # Close all client connections
        for client_socket, _ in self.connections:
            try:
                client_socket.close()
            except:
                pass
        
        # Close server socket
        if self.server_socket:
            try:
                self.server_socket.close()
            except:
                pass
                
        logger.info("Mock Lua server stopped")
    
    def handle_client(self, client_socket, client_address):
        """Handle a client connection."""
        authenticated = False
        buffer = ""
        
        try:
            while self.running:
                data = client_socket.recv(4096)
                if not data:
                    logger.info(f"Connection closed by client {client_address}")
                    break
                
                # Add received data to buffer
                buffer += data.decode('utf-8')
                
                # Process complete messages
                while '\n' in buffer:
                    message, buffer = buffer.split('\n', 1)
                    
                    # Process message
                    if not authenticated:
                        response = self.handle_authentication(message)
                        authenticated = response.get("status") == "success"
                    else:
                        response = self.handle_command(message)
                    
                    # Send response
                    response_json = json.dumps(response) + '\n'
                    client_socket.sendall(response_json.encode('utf-8'))
        
        except Exception as e:
            logger.error(f"Error handling client {client_address}: {e}")
        finally:
            client_socket.close()
    
    def handle_authentication(self, message):
        """Handle authentication messages."""
        try:
            data = json.loads(message)
            if data.get("auth_token") == self.auth_token:
                logger.info("Authentication successful")
                return {
                    "status": "success",
                    "result": {
                        "message": "Authentication successful",
                        "data": {
                            "server_info": {
                                "version": "1.0.0",
                                "name": "Mock Lua Gadget"
                            }
                        }
                    }
                }
            else:
                logger.warning("Authentication failed: Invalid token")
                return {
                    "status": "error",
                    "result": {
                        "message": "Authentication failed: Invalid token",
                        "type": "authentication_error"
                    }
                }
        except json.JSONDecodeError:
            logger.error("Authentication failed: Invalid JSON")
            return {
                "status": "error",
                "result": {
                    "message": "Invalid JSON in authentication request",
                    "type": "syntax_error"
                }
            }
    
    def handle_command(self, message):
        """Handle command messages."""
        try:
            data = json.loads(message)
            command_type = data.get("command_type", "")
            payload = data.get("payload", {})
            command_id = data.get("id", "unknown")
            
            logger.info(f"Received command: {command_type} (ID: {command_id})")
            
            # Handle different command types
            if command_type == "execute_code":
                return self.execute_code(payload.get("code", ""), command_id)
            elif command_type == "execute_function":
                return self.execute_function(
                    payload.get("function", ""),
                    payload.get("parameters", {}),
                    command_id
                )
            elif command_type == "query_state":
                return self.query_state(command_id)
            else:
                logger.warning(f"Unknown command type: {command_type}")
                return {
                    "status": "error",
                    "result": {
                        "message": f"Unknown command type: {command_type}",
                        "type": "validation_error"
                    },
                    "command_id": command_id
                }
        
        except json.JSONDecodeError:
            logger.error("Command parsing failed: Invalid JSON")
            return {
                "status": "error",
                "result": {
                    "message": "Invalid JSON in command request",
                    "type": "syntax_error"
                }
            }
        except Exception as e:
            logger.error(f"Error processing command: {e}")
            return {
                "status": "error",
                "result": {
                    "message": f"Error processing command: {str(e)}",
                    "type": "runtime_error"
                }
            }
    
    def execute_code(self, code, command_id):
        """Execute arbitrary Lua code (simulated)."""
        # For testing, we'll recognize certain code patterns and respond accordingly
        try:
            execution_start = time.time()
            
            # Simulate long-running operation
            if "sleep" in code or "delay" in code:
                time.sleep(1.0)  # Simulate delay
            
            # Simulate error
            if "error" in code or "fail" in code:
                return {
                    "status": "error",
                    "result": {
                        "message": "Execution failed: Error in Lua code",
                        "type": "runtime_error",
                        "data": {
                            "code": code,
                            "error_line": 1
                        }
                    },
                    "command_id": command_id,
                    "execution_time": int((time.time() - execution_start) * 1000)
                }
            
            # Simulate specific operations
            if "create_circle" in code:
                return {
                    "status": "success",
                    "result": {
                        "message": "Circle created successfully",
                        "data": {
                            "object_id": "mock_circle_1",
                            "properties": {
                                "center_x": 100,
                                "center_y": 100,
                                "radius": 50
                            }
                        }
                    },
                    "command_id": command_id,
                    "execution_time": int((time.time() - execution_start) * 1000)
                }
            
            # Default success response
            return {
                "status": "success",
                "result": {
                    "message": "Code executed successfully",
                    "data": {
                        "result": "mock_result",
                        "code_executed": code
                    }
                },
                "command_id": command_id,
                "execution_time": int((time.time() - execution_start) * 1000)
            }
            
        except Exception as e:
            return {
                "status": "error",
                "result": {
                    "message": f"Error executing code: {str(e)}",
                    "type": "runtime_error"
                },
                "command_id": command_id
            }
    
    def execute_function(self, function_name, parameters, command_id):
        """Execute a named function with parameters."""
        try:
            execution_start = time.time()
            
            # Check if the function exists in our mock SDK
            if hasattr(self.sdk, function_name):
                func = getattr(self.sdk, function_name)
                result = func(parameters)
                
                return {
                    "status": "success",
                    "result": {
                        "message": f"Function {function_name} executed successfully",
                        "data": result
                    },
                    "command_id": command_id,
                    "execution_time": int((time.time() - execution_start) * 1000)
                }
            else:
                return {
                    "status": "error",
                    "result": {
                        "message": f"Unknown function: {function_name}",
                        "type": "validation_error"
                    },
                    "command_id": command_id
                }
                
        except Exception as e:
            return {
                "status": "error",
                "result": {
                    "message": f"Error executing function: {str(e)}",
                    "type": "runtime_error"
                },
                "command_id": command_id
            }
    
    def query_state(self, command_id):
        """Return the current state of the mock Vectric environment."""
        try:
            state = self.sdk.get_current_state()
            
            return {
                "status": "success",
                "result": {
                    "message": "Current state retrieved successfully",
                    "data": state
                },
                "command_id": command_id
            }
        except Exception as e:
            return {
                "status": "error",
                "result": {
                    "message": f"Error retrieving state: {str(e)}",
                    "type": "runtime_error"
                },
                "command_id": command_id
            }

if __name__ == "__main__":
    # When run directly, start the mock server
    server = MockLuaServer()
    try:
        server.start()
    except KeyboardInterrupt:
        logger.info("Server stopped by user")
        server.stop()
