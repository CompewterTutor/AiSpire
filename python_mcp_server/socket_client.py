"""
Socket client module for communicating with the Lua Gadget.

This module provides a client that connects to the Lua Gadget socket server
and handles sending commands and receiving responses.
"""

import asyncio
import json
import logging
import time
from typing import Optional, Dict, Any, Union

logger = logging.getLogger(__name__)

class LuaSocketClient:
    """
    Client for communicating with the Lua Gadget socket server.
    Handles connection management, authentication, and command execution.
    """
    
    def __init__(self, host: str = "localhost", port: int = 9876, connect_timeout: float = 5.0):
        """
        Initialize the socket client.
        
        Args:
            host: Hostname of the Lua socket server
            port: Port of the Lua socket server
            connect_timeout: Connection timeout in seconds
        """
        self.host = host
        self.port = port
        self.connect_timeout = connect_timeout
        self._socket = None
        self._reader = None
        self._writer = None
        self._is_connected = False
        self._reconnect_delay = 1.0  # Initial reconnect delay in seconds
        self._max_reconnect_delay = 30.0  # Maximum reconnect delay in seconds
        self._auth_token = None
        self._lock = asyncio.Lock()
    
    async def connect(self, host: Optional[str] = None, port: Optional[int] = None, 
                    auth_token: Optional[str] = None) -> bool:
        """
        Connect to the Lua socket server.
        
        Args:
            host: Override the hostname
            port: Override the port
            auth_token: Authentication token for the Lua server
            
        Returns:
            True if connected successfully, False otherwise
            
        Raises:
            ConnectionError: If connection fails
            TimeoutError: If connection times out
            ValueError: If authentication fails
        """
        if host is not None:
            self.host = host
        if port is not None:
            self.port = port
        if auth_token is not None:
            self._auth_token = auth_token
        
        try:
            # Connect to the server
            self._reader, self._writer = await asyncio.wait_for(
                asyncio.open_connection(self.host, self.port),
                timeout=self.connect_timeout
            )
            
            # Authenticate if token provided
            if self._auth_token:
                auth_msg = json.dumps({
                    "auth_token": self._auth_token
                }) + "\n"
                self._writer.write(auth_msg.encode())
                await self._writer.drain()
                
                # Wait for auth response
                resp = await self._reader.readline()
                if not resp:
                    raise ConnectionError("Connection closed during authentication")
                
                auth_response = json.loads(resp.decode())
                if auth_response.get("status") != "success":
                    error_msg = auth_response.get("result", {}).get(
                        "message", "Authentication failed"
                    )
                    raise ValueError(f"Authentication error: {error_msg}")
            
            self._is_connected = True
            self._reconnect_delay = 1.0  # Reset reconnect delay
            logger.info(f"Connected to Lua server at {self.host}:{self.port}")
            return True
            
        except asyncio.TimeoutError:
            logger.error(f"Connection to {self.host}:{self.port} timed out")
            raise TimeoutError(f"Connection to {self.host}:{self.port} timed out")
            
        except (ConnectionRefusedError, ConnectionError) as e:
            logger.error(f"Connection to {self.host}:{self.port} failed: {e}")
            raise ConnectionError(f"Failed to connect to {self.host}:{self.port}: {e}")
    
    def is_connected(self) -> bool:
        """
        Check if connected to the Lua server.
        
        Returns:
            True if connected, False otherwise
        """
        return self._is_connected
    
    async def disconnect(self) -> None:
        """
        Disconnect from the Lua server.
        """
        if self._writer:
            try:
                self._writer.close()
                await self._writer.wait_closed()
            except Exception as e:
                logger.warning(f"Error closing connection: {e}")
        
        self._is_connected = False
        self._reader = None
        self._writer = None
        logger.info("Disconnected from Lua server")
    
    def disconnect_sync(self) -> None:
        """
        Synchronously disconnect from the Lua server.
        This is a convenience method for non-async contexts.
        """
        if self._writer:
            try:
                self._writer.close()
            except Exception as e:
                logger.warning(f"Error closing connection: {e}")
        
        self._is_connected = False
        self._reader = None
        self._writer = None
        logger.info("Disconnected from Lua server (sync)")
    
    async def _ensure_connected(self) -> bool:
        """
        Ensure that we're connected to the Lua server.
        Attempts to reconnect if not connected.
        
        Returns:
            True if connected, False if reconnection failed
        """
        if self.is_connected():
            return True
        
        logger.info("Not connected to Lua server, attempting reconnect")
        try:
            await self.connect()
            return True
        except Exception as e:
            logger.error(f"Reconnection failed: {e}")
            
            # Exponential backoff for reconnect
            await asyncio.sleep(self._reconnect_delay)
            self._reconnect_delay = min(
                self._reconnect_delay * 2, 
                self._max_reconnect_delay
            )
            return False
    
    async def send_command(self, command: Union[str, Dict[str, Any]]) -> str:
        """
        Send a command to the Lua server and get the response.
        
        Args:
            command: Command string (JSON) or dictionary to send
            
        Returns:
            Response string from the server
            
        Raises:
            ConnectionError: If not connected and reconnect fails
            TimeoutError: If response times out
            ValueError: If command is invalid
        """
        async with self._lock:  # Ensure only one command is sent at a time
            # Convert dict to string if needed
            if isinstance(command, dict):
                command = json.dumps(command)
            
            # Ensure we're connected
            if not await self._ensure_connected():
                raise ConnectionError("Not connected to Lua server and reconnect failed")
            
            try:
                # Send the command with newline terminator
                if not command.endswith("\n"):
                    command += "\n"
                self._writer.write(command.encode())
                await self._writer.drain()
                
                # Read response
                response = await self._reader.readline()
                if not response:
                    # Connection closed
                    self._is_connected = False
                    raise ConnectionError("Connection closed by server")
                
                return response.decode()
                
            except Exception as e:
                self._is_connected = False
                logger.error(f"Error sending command: {e}")
                raise
