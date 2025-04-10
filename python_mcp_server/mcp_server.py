"""
MCP Server implementation for AiSpire.
Handles LLM communication via Model Context Protocol.
"""
import json
import logging
import asyncio
from typing import Dict, Any, Optional

from .socket_client import LuaSocketClient
from .command_generator import CommandGenerator
from .result_handler import ResultHandler, ErrorCategory
from .mcp.protocol import MCPProcessor, MCPMessage, MCPMessageType
from .llm.handler import LLMHandler

logger = logging.getLogger(__name__)


class McpServer:
    """
    Model Context Protocol server for handling LLM requests.
    Routes LLM commands to the Lua gadget and formats responses.
    """
    
    def __init__(self, host: str = "localhost", port: int = 8765, 
                 lua_host: str = "localhost", lua_port: int = 9876):
        """
        Initialize the MCP server.
        
        Args:
            host: Hostname to bind the server
            port: Port to bind the server
            lua_host: Hostname of the Lua socket server
            lua_port: Port of the Lua socket server
        """
        self.host = host
        self.port = port
        self.lua_client = LuaSocketClient(lua_host, lua_port)
        self.command_generator = CommandGenerator()
        self.running = False
        self.server = None
        self.processor = MCPProcessor()
        self.llm_handler = LLMHandler(self.lua_client, self.command_generator)
        
    async def start(self):
        """Start the MCP server and connect to the Lua gadget."""
        try:
            # Connect to Lua Gadget
            await self.lua_client.connect()
            
            # Register LLM handlers with the MCP processor
            self.llm_handler.register_handlers(self.processor)
            
            # Start server
            self.server = await asyncio.start_server(
                self.handle_client, self.host, self.port
            )
            self.running = True
            
            addr = self.server.sockets[0].getsockname()
            logger.info(f"MCP Server started on {addr}")
            
            async with self.server:
                await self.server.serve_forever()
        except Exception as e:
            logger.error(f"Failed to start MCP server: {e}")
            self.running = False
            raise
            
    async def stop(self):
        """Stop the MCP server and disconnect from the Lua gadget."""
        if self.server:
            self.server.close()
            await self.server.wait_closed()
        await self.lua_client.disconnect()
        self.running = False
        logger.info("MCP Server stopped")
        
    async def handle_client(self, reader: asyncio.StreamReader, writer: asyncio.StreamWriter):
        """
        Handle a client connection.
        
        Args:
            reader: Stream reader for client data
            writer: Stream writer for client responses
        """
        addr = writer.get_extra_info('peername')
        logger.info(f"Connection from {addr}")
        
        try:
            data = await reader.read(4096)  # Adjust buffer size as needed
            if data:
                message = data.decode()
                logger.debug(f"Received message: {message}")
                
                response = await self.process_message(message)
                writer.write(json.dumps(response).encode())
                await writer.drain()
                
        except Exception as e:
            logger.error(f"Error handling client: {e}")
            error_response = ResultHandler.format_error_response(
                message=f"Internal server error: {str(e)}",
                category=ErrorCategory.UNKNOWN
            )
            try:
                writer.write(json.dumps(error_response).encode())
                await writer.drain()
            except:
                pass  # If writing error response fails, just continue to cleanup
                
        finally:
            writer.close()
            try:
                await writer.wait_closed()
            except:
                pass  # Ignore errors during connection cleanup
            logger.info(f"Connection closed for {addr}")
    
    async def process_message(self, message: str) -> Dict[str, Any]:
        """
        Process a message from a client.
        
        Args:
            message: JSON message string from client
            
        Returns:
            Response dictionary
        """
        try:
            # First try to parse the message as JSON
            try:
                request_data = json.loads(message)
                command_id = request_data.get("id", "unknown")
            except json.JSONDecodeError:
                return ResultHandler.format_error_response(
                    message="Invalid JSON in request",
                    category=ErrorCategory.SYNTAX,
                    command_id=None
                )
                
            # Process using MCP processor
            mcp_message = self.processor.process_message(message)
            if mcp_message:
                # Return JSON serializable dict from MCP message
                return mcp_message.to_dict()
            else:
                # Legacy processing for backward compatibility
                # Generate Lua command from request
                lua_command = self.command_generator.generate_command(request_data)
                
                # Send to Lua Gadget
                lua_response = await self.lua_client.send_command(lua_command)
                
                # Parse and process response
                parsed_response = ResultHandler.parse_response(lua_response)
                return ResultHandler.process_lua_response(parsed_response, command_id)
                
        except Exception as e:
            logger.error(f"Error processing message: {e}")
            return ResultHandler.format_error_response(
                message=f"Error processing request: {str(e)}",
                category=ErrorCategory.UNKNOWN,
                command_id=None
            )
