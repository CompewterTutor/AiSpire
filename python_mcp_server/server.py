"""
AiSpire MCP Server

This server implements the Model Context Protocol (MCP) for integrating
LLM capabilities with the Vectric Aspire/V-Carve CAD/CAM environment via
a socket connection to the AiSpire Lua Gadget.

Author: AiSpire Team
Version: 0.1.0 (Development)
Date: April 11, 2025
"""

import asyncio
import json
import logging
import os
import time
from typing import Dict, Any, Optional, List, Union
import socket
from http.server import HTTPServer, BaseHTTPRequestHandler
import threading

# Local imports
from .config import load_config
from .metrics import initialize_metrics, get_metrics

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger("aispire_mcp")

# Default configuration
DEFAULT_CONFIG = {
    "lua_gadget": {
        "host": "127.0.0.1",
        "port": 9876,
        "auth_token": "change_this_to_a_secure_token",
        "connection_timeout": 5.0,
        "reconnect_attempts": 3,
        "reconnect_delay": 2.0,
    },
    "mcp_server": {
        "host": "127.0.0.1",
        "port": 8765,
        "allowed_origins": ["http://localhost:3000"],
        "auth_required": True,
        "auth_token": os.environ.get("AISPIRE_MCP_AUTH_TOKEN", "change_this_to_a_secure_token"),
    },
    "logging": {
        "level": "INFO",
        "file": None,
    },
    "metrics": {
        "enabled": True,
        "history_size": 1000,
        "reporting_interval": 60,
        "alert_thresholds": {
            "request_latency": 1000,
            "lua_execution_time": 5000,
            "error_rate": 0.05,
            "connection_failures": 5
        },
        "expose_prometheus": True,
        "prometheus_port": 9090
    }
}

class LuaGadgetClient:
    """Client for communicating with the AiSpire Lua Gadget over a socket connection."""
    
    def __init__(self, config: Dict[str, Any]):
        """Initialize the Lua Gadget client.
        
        Args:
            config: Configuration dictionary with connection parameters
        """
        self.host = config["host"]
        self.port = config["port"]
        self.auth_token = config["auth_token"]
        self.timeout = config["connection_timeout"]
        self.reconnect_attempts = config["reconnect_attempts"]
        self.reconnect_delay = config["reconnect_delay"]
        self.reader = None
        self.writer = None
        self.connected = False
    
    async def connect(self) -> bool:
        """Establish a connection to the Lua Gadget.
        
        Returns:
            bool: True if connection was successful, False otherwise
        """
        attempts = 0
        while attempts < self.reconnect_attempts:
            try:
                logger.info(f"Connecting to Lua Gadget at {self.host}:{self.port}")
                self.reader, self.writer = await asyncio.wait_for(
                    asyncio.open_connection(self.host, self.port),
                    timeout=self.timeout
                )
                self.connected = True
                logger.info("Connected to Lua Gadget")
                
                # Record successful connection in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_connection_attempt(True)
                
                return True
            except (ConnectionRefusedError, asyncio.TimeoutError) as e:
                attempts += 1
                logger.warning(f"Connection attempt {attempts} failed: {str(e)}")
                
                # Record failed connection in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_connection_attempt(False)
                
                if attempts < self.reconnect_attempts:
                    logger.info(f"Retrying in {self.reconnect_delay} seconds...")
                    await asyncio.sleep(self.reconnect_delay)
                else:
                    logger.error("Failed to connect to Lua Gadget after maximum attempts")
        
        return False
    
    async def disconnect(self) -> None:
        """Close the connection to the Lua Gadget."""
        if self.writer:
            self.writer.close()
            await self.writer.wait_closed()
        self.connected = False
        self.reader = None
        self.writer = None
        logger.info("Disconnected from Lua Gadget")
    
    async def execute_code(self, code: str, command_id: str) -> Dict[str, Any]:
        """Execute Lua code on the Gadget.
        
        Args:
            code: The Lua code to execute
            command_id: Unique identifier for this command
            
        Returns:
            Dict containing the response from the Lua Gadget
        """
        start_time = time.time()
        
        if not self.connected:
            if not await self.connect():
                # Record error in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_error("connection_error")
                
                return {
                    "status": "error",
                    "result": {
                        "message": "Not connected to Lua Gadget",
                        "data": {},
                        "type": "connection_error"
                    },
                    "command_id": command_id,
                    "execution_time": 0
                }
        
        command = {
            "command_type": "execute_code",
            "payload": {
                "code": code
            },
            "id": command_id,
            "auth": self.auth_token
        }
        
        response = await self._send_command(command)
        
        # Record metrics
        end_time = time.time()
        latency_ms = (end_time - start_time) * 1000
        
        metrics = get_metrics()
        if metrics:
            metrics.record_request_latency(latency_ms)
            if "execution_time" in response:
                metrics.record_execution_time(response["execution_time"])
            if response["status"] == "error":
                metrics.record_error(response["result"].get("type", "unknown_error"))
        
        return response
    
    async def execute_function(self, function_name: str, parameters: Dict[str, Any], command_id: str) -> Dict[str, Any]:
        """Execute a specific function on the Lua Gadget.
        
        Args:
            function_name: Name of the function to execute
            parameters: Parameters to pass to the function
            command_id: Unique identifier for this command
            
        Returns:
            Dict containing the response from the Lua Gadget
        """
        start_time = time.time()
        
        if not self.connected:
            if not await self.connect():
                # Record error in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_error("connection_error")
                
                return {
                    "status": "error",
                    "result": {
                        "message": "Not connected to Lua Gadget",
                        "data": {},
                        "type": "connection_error"
                    },
                    "command_id": command_id,
                    "execution_time": 0
                }
        
        command = {
            "command_type": "execute_function",
            "payload": {
                "function": function_name,
                "parameters": parameters
            },
            "id": command_id,
            "auth": self.auth_token
        }
        
        response = await self._send_command(command)
        
        # Record metrics
        end_time = time.time()
        latency_ms = (end_time - start_time) * 1000
        
        metrics = get_metrics()
        if metrics:
            metrics.record_request_latency(latency_ms)
            if "execution_time" in response:
                metrics.record_execution_time(response["execution_time"])
            if response["status"] == "error":
                metrics.record_error(response["result"].get("type", "unknown_error"))
        
        return response
    
    async def query_state(self, command_id: str) -> Dict[str, Any]:
        """Query the current state of the Lua Gadget.
        
        Args:
            command_id: Unique identifier for this command
            
        Returns:
            Dict containing the response from the Lua Gadget
        """
        start_time = time.time()
        
        if not self.connected:
            if not await self.connect():
                # Record error in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_error("connection_error")
                
                return {
                    "status": "error",
                    "result": {
                        "message": "Not connected to Lua Gadget",
                        "data": {},
                        "type": "connection_error"
                    },
                    "command_id": command_id,
                    "execution_time": 0
                }
        
        command = {
            "command_type": "query_state",
            "payload": {},
            "id": command_id,
            "auth": self.auth_token
        }
        
        response = await self._send_command(command)
        
        # Record metrics
        end_time = time.time()
        latency_ms = (end_time - start_time) * 1000
        
        metrics = get_metrics()
        if metrics:
            metrics.record_request_latency(latency_ms)
            if response["status"] == "error":
                metrics.record_error(response["result"].get("type", "unknown_error"))
        
        return response
    
    async def _send_command(self, command: Dict[str, Any]) -> Dict[str, Any]:
        """Send a command to the Lua Gadget and receive the response.
        
        Args:
            command: The command to send
            
        Returns:
            Dict containing the response from the Lua Gadget
        """
        try:
            # Serialize command to JSON
            command_json = json.dumps(command) + "\n"
            
            # Send the command
            self.writer.write(command_json.encode())
            await self.writer.drain()
            
            # Receive the response
            response_json = await self.reader.readline()
            if not response_json:
                # Connection closed
                self.connected = False
                
                # Record error in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_error("connection_closed")
                
                return {
                    "status": "error",
                    "result": {
                        "message": "Connection closed by Lua Gadget",
                        "data": {},
                        "type": "connection_error"
                    },
                    "command_id": command["id"],
                    "execution_time": 0
                }
            
            # Parse the response
            try:
                response = json.loads(response_json.decode())
                return response
            except json.JSONDecodeError:
                # Record error in metrics
                metrics = get_metrics()
                if metrics:
                    metrics.record_error("parsing_error")
                
                return {
                    "status": "error",
                    "result": {
                        "message": "Invalid JSON response from Lua Gadget",
                        "data": {},
                        "type": "parsing_error"
                    },
                    "command_id": command["id"],
                    "execution_time": 0
                }
                
        except Exception as e:
            self.connected = False
            
            # Record error in metrics
            metrics = get_metrics()
            if metrics:
                metrics.record_error("communication_error")
            
            return {
                "status": "error",
                "result": {
                    "message": f"Error communicating with Lua Gadget: {str(e)}",
                    "data": {},
                    "type": "communication_error"
                },
                "command_id": command["id"],
                "execution_time": 0
            }


class MCPServer:
    """MCP Server implementation for AiSpire."""
    
    def __init__(self, config: Dict[str, Any], lua_client: LuaGadgetClient):
        """Initialize the MCP Server.
        
        Args:
            config: Configuration dictionary with server parameters
            lua_client: Client for communicating with the Lua Gadget
        """
        self.host = config["host"]
        self.port = config["port"]
        self.allowed_origins = config["allowed_origins"]
        self.auth_required = config["auth_required"]
        self.auth_token = config["auth_token"]
        self.lua_client = lua_client
        self.server = None
        self.metrics_server = None
        self.metrics_thread = None
    
    async def start(self) -> None:
        """Start the MCP server."""
        logger.info(f"Starting MCP Server on {self.host}:{self.port}")
        
        # Connect to Lua Gadget
        if not await self.lua_client.connect():
            logger.warning("MCP Server started without connection to Lua Gadget")
        
        # Start Prometheus metrics HTTP server if enabled
        metrics = get_metrics()
        metrics_config = load_config()["metrics"]
        if metrics and metrics_config["expose_prometheus"]:
            self._start_metrics_server(metrics_config["prometheus_port"])
            logger.info(f"Prometheus metrics server started on port {metrics_config['prometheus_port']}")
        
        # This is a placeholder for the actual MCP server implementation
        # In a real implementation, this would set up websocket handlers
        # and implement the MCP protocol
        logger.info("MCP Server started")
        
        # For now, just create a simple test server that echoes incoming messages
        self.server = await asyncio.start_server(
            self._handle_connection, self.host, self.port
        )
        
        async with self.server:
            await self.server.serve_forever()
    
    async def stop(self) -> None:
        """Stop the MCP server."""
        if self.server:
            self.server.close()
            await self.server.wait_closed()
        
        await self.lua_client.disconnect()
        
        # Stop metrics server if running
        if self.metrics_server:
            logger.info("Stopping Prometheus metrics server")
            self.metrics_server.shutdown()
            if self.metrics_thread and self.metrics_thread.is_alive():
                self.metrics_thread.join(timeout=1.0)
        
        # Shutdown metrics system
        metrics = get_metrics()
        if metrics:
            metrics.shutdown()
        
        logger.info("MCP Server stopped")
    
    def _start_metrics_server(self, port: int) -> None:
        """Start an HTTP server to expose Prometheus metrics.
        
        Args:
            port: Port to run the server on
        """
        class MetricsHandler(BaseHTTPRequestHandler):
            def do_GET(self):
                metrics = get_metrics()
                if metrics and self.path == '/metrics':
                    self.send_response(200)
                    self.send_header('Content-Type', 'text/plain')
                    self.end_headers()
                    self.wfile.write(metrics.export_prometheus().encode())
                elif self.path == '/health':
                    self.send_response(200)
                    self.send_header('Content-Type', 'text/plain')
                    self.end_headers()
                    self.wfile.write(b'OK')
                else:
                    self.send_response(404)
                    self.send_header('Content-Type', 'text/plain')
                    self.end_headers()
                    self.wfile.write(b'Not Found')
            
            def log_message(self, format, *args):
                # Redirect HTTP server logs to our logger
                logger.debug(f"Metrics server: {format % args}")
        
        def run_metrics_server():
            server = HTTPServer(('', port), MetricsHandler)
            self.metrics_server = server
            try:
                server.serve_forever()
            except Exception as e:
                logger.error(f"Error in metrics server: {str(e)}")
        
        self.metrics_thread = threading.Thread(target=run_metrics_server, daemon=True)
        self.metrics_thread.start()
    
    async def _handle_connection(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter) -> None:
        """Handle a new client connection.
        
        Args:
            reader: StreamReader for receiving data
            writer: StreamWriter for sending data
        """
        addr = writer.get_extra_info('peername')
        logger.info(f"New connection from {addr}")
        
        try:
            while True:
                start_time = time.time()
                data = await reader.readline()
                if not data:
                    break
                
                message = data.decode()
                logger.info(f"Received: {message}")
                
                try:
                    # Parse the client request
                    request = json.loads(message)
                    
                    # Check authentication if required
                    if self.auth_required:
                        if "auth" not in request or request["auth"] != self.auth_token:
                            response = {
                                "status": "error",
                                "error": "Authentication failed"
                            }
                            writer.write(json.dumps(response).encode() + b'\n')
                            await writer.drain()
                            
                            # Record authentication error
                            metrics = get_metrics()
                            if metrics:
                                metrics.record_error("authentication_failed")
                            
                            continue
                    
                    # Process the request based on its type
                    if "type" not in request:
                        response = {
                            "status": "error",
                            "error": "Missing request type"
                        }
                        
                        # Record validation error
                        metrics = get_metrics()
                        if metrics:
                            metrics.record_error("validation_error")
                    elif request["type"] == "execute_lua":
                        # Forward to Lua Gadget
                        if "code" not in request:
                            response = {
                                "status": "error",
                                "error": "Missing code parameter"
                            }
                            
                            # Record validation error
                            metrics = get_metrics()
                            if metrics:
                                metrics.record_error("validation_error")
                        else:
                            lua_response = await self.lua_client.execute_code(
                                request["code"], 
                                request.get("id", "unknown")
                            )
                            response = {
                                "status": "success",
                                "result": lua_response
                            }
                    else:
                        response = {
                            "status": "error",
                            "error": f"Unknown request type: {request['type']}"
                        }
                        
                        # Record unknown request type error
                        metrics = get_metrics()
                        if metrics:
                            metrics.record_error("unknown_request_type")
                    
                    # Send response back to client
                    writer.write(json.dumps(response).encode() + b'\n')
                    await writer.drain()
                    
                    # Record request latency
                    end_time = time.time()
                    latency_ms = (end_time - start_time) * 1000
                    
                    metrics = get_metrics()
                    if metrics:
                        metrics.record_request_latency(latency_ms)
                    
                except json.JSONDecodeError:
                    response = {
                        "status": "error",
                        "error": "Invalid JSON request"
                    }
                    writer.write(json.dumps(response).encode() + b'\n')
                    await writer.drain()
                    
                    # Record parsing error
                    metrics = get_metrics()
                    if metrics:
                        metrics.record_error("json_parsing_error")
                
        except Exception as e:
            logger.error(f"Error handling connection: {str(e)}")
            
            # Record error
            metrics = get_metrics()
            if metrics:
                metrics.record_error("connection_handler_error")
        finally:
            writer.close()
            await writer.wait_closed()
            logger.info(f"Connection closed for {addr}")


async def main() -> None:
    """Main function to start the AiSpire MCP Server."""
    # Load configuration from file or environment
    config = load_config()
    
    # Set up logging
    log_level = getattr(logging, config["logging"]["level"])
    logger.setLevel(log_level)
    if config["logging"]["file"]:
        file_handler = logging.FileHandler(config["logging"]["file"])
        file_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        file_handler.setFormatter(file_formatter)
        logger.addHandler(file_handler)
    
    # Initialize metrics
    metrics = initialize_metrics(config["metrics"])
    logger.info(f"Metrics system initialized (enabled: {metrics.enabled})")
    
    # Create Lua Gadget client
    lua_client = LuaGadgetClient(config["lua_gadget"])
    
    # Create and start MCP server
    mcp_server = MCPServer(config["mcp_server"], lua_client)
    
    try:
        await mcp_server.start()
    except asyncio.CancelledError:
        logger.info("Server shutdown requested")
    finally:
        await mcp_server.stop()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Server stopped by user")