"""
LLM Handler for AiSpire MCP Server.

This module provides handlers for processing requests from language models
and translating them into commands for the Vectric Lua Gadget.
"""

import logging
import json
from typing import Dict, Any, Optional, List, Callable, Union

from ..mcp.protocol import (
    MCPMessage,
    MCPMessageType,
    MCPContentType,
    MCPCommandMessage,
    MCPResultMessage,
    MCPSession,
    MCPProcessor
)
from ..socket_client import LuaSocketClient
from ..command_generator import CommandGenerator
from ..result_handler import ResultHandler, ResultType, ErrorCategory

logger = logging.getLogger(__name__)


class LLMHandler:
    """
    Handler for processing LLM requests via the MCP protocol.
    
    This class provides methods for registering handlers with the MCP processor,
    parsing LLM requests, and formatting responses.
    """
    
    def __init__(self, lua_client: LuaSocketClient, command_generator: CommandGenerator):
        """
        Initialize the LLM handler.
        
        Args:
            lua_client: Client for communicating with the Lua Gadget
            command_generator: Generator for creating Lua commands
        """
        self.lua_client = lua_client
        self.command_generator = command_generator
        self.handlers: Dict[str, Callable] = {}
        
        # Register default command handlers
        self._register_default_handlers()
    
    def _register_default_handlers(self) -> None:
        """Register default command handlers."""
        # Map command types to handler functions
        self.handlers = {
            "execute_code": self.handle_execute_code,
            "execute_function": self.handle_execute_function,
            "query_state": self.handle_query_state,
        }
    
    def register_handlers(self, processor: MCPProcessor) -> None:
        """
        Register handlers with the MCP processor.
        
        Args:
            processor: MCP processor to register handlers with
        """
        # Register command handler
        processor.register_handler(MCPMessageType.COMMAND, self.handle_command)
        
        # Also register for "request" type messages for general interface
        processor.register_handler(MCPMessageType.REQUEST, self.handle_request)
        
        logger.info("Registered LLM handlers with MCP processor")
    
    async def handle_command(self, message: MCPMessage) -> MCPMessage:
        """
        Handle an MCP command message.
        
        Args:
            message: MCP command message
            
        Returns:
            Response message
        """
        # Validate message has command_type
        if not isinstance(message.content, dict) or "command_type" not in message.content:
            return MCPResultMessage.error(
                error_message="Invalid command: missing command_type",
                error_type="validation_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
        
        # Extract command details
        command_type = message.content["command_type"]
        payload = message.content.get("payload", {})
        
        # Find the appropriate handler
        if command_type in self.handlers:
            try:
                return await self.handlers[command_type](payload, message)
            except Exception as e:
                logger.exception(f"Error handling {command_type} command: {e}")
                return MCPResultMessage.error(
                    error_message=f"Error handling {command_type} command: {str(e)}",
                    error_type="handler_error",
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
        else:
            return MCPResultMessage.error(
                error_message=f"Unknown command type: {command_type}",
                error_type="unknown_command",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
    
    async def handle_request(self, message: MCPMessage) -> MCPMessage:
        """
        Handle a general MCP request message (for simpler interface).
        
        Args:
            message: MCP request message
            
        Returns:
            Response message
        """
        # This is a simplified handler for generic requests that don't use the command structure
        # It allows for simpler interfaces like "create a circle" without specifying command_type
        
        # For now, treat the content as a natural language request and process accordingly
        if isinstance(message.content, str):
            try:
                # Here we would implement natural language parsing
                # For now, just return a simple response
                return MCPResultMessage.success(
                    message="Received natural language request. Natural language processing not yet implemented.",
                    result_data={"request": message.content},
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            except Exception as e:
                logger.exception(f"Error processing natural language request: {e}")
                return MCPResultMessage.error(
                    error_message=f"Error processing request: {str(e)}",
                    error_type="processing_error",
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
        else:
            return MCPResultMessage.error(
                error_message="Invalid request format. Expected text content.",
                error_type="validation_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
    
    async def handle_execute_code(self, payload: Dict[str, Any], message: MCPMessage) -> MCPMessage:
        """
        Handle an execute_code command.
        
        Args:
            payload: Command payload
            message: Original MCP message
            
        Returns:
            Result message
        """
        if "code" not in payload:
            return MCPResultMessage.error(
                error_message="Missing code parameter",
                error_type="validation_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
        
        code = payload["code"]
        options = payload.get("options", {})
        
        try:
            # Execute the code via the Lua client
            response = await self.lua_client.execute_code(code, message.message_id)
            
            # Parse the response
            if isinstance(response, str):
                lua_result = ResultHandler.parse_response(response)
            else:
                lua_result = response
            
            # Format based on status
            if lua_result["status"] == ResultType.SUCCESS.value:
                return MCPResultMessage.success(
                    result_data=lua_result["result"].get("data"),
                    message=lua_result["result"]["message"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            elif lua_result["status"] == ResultType.ERROR.value:
                return MCPResultMessage.error(
                    error_message=lua_result["result"]["message"],
                    error_data=lua_result["result"].get("data"),
                    error_type=lua_result["result"]["type"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            elif lua_result["status"] == ResultType.IN_PROGRESS.value:
                return MCPResultMessage.in_progress(
                    progress_data=lua_result["result"].get("data"),
                    message=lua_result["result"]["message"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            else:
                return MCPResultMessage.error(
                    error_message=f"Unknown response status: {lua_result['status']}",
                    error_type="unknown_status",
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
                
        except Exception as e:
            logger.exception(f"Error executing Lua code: {e}")
            return MCPResultMessage.error(
                error_message=f"Error executing code: {str(e)}",
                error_type="execution_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
    
    async def handle_execute_function(self, payload: Dict[str, Any], message: MCPMessage) -> MCPMessage:
        """
        Handle an execute_function command.
        
        Args:
            payload: Command payload
            message: Original MCP message
            
        Returns:
            Result message
        """
        if "function" not in payload:
            return MCPResultMessage.error(
                error_message="Missing function parameter",
                error_type="validation_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
        
        function_name = payload["function"]
        parameters = payload.get("parameters", {})
        options = payload.get("options", {})
        
        try:
            # Generate and execute the function via the command generator and Lua client
            command = self.command_generator.generate_function_command(
                function_name, parameters, options
            )
            
            response = await self.lua_client.execute_function(
                function_name, parameters, message.message_id
            )
            
            # Parse the response
            if isinstance(response, str):
                lua_result = ResultHandler.parse_response(response)
            else:
                lua_result = response
            
            # Format based on status (similar to execute_code)
            if lua_result["status"] == ResultType.SUCCESS.value:
                return MCPResultMessage.success(
                    result_data=lua_result["result"].get("data"),
                    message=lua_result["result"]["message"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            elif lua_result["status"] == ResultType.ERROR.value:
                return MCPResultMessage.error(
                    error_message=lua_result["result"]["message"],
                    error_data=lua_result["result"].get("data"),
                    error_type=lua_result["result"]["type"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            elif lua_result["status"] == ResultType.IN_PROGRESS.value:
                return MCPResultMessage.in_progress(
                    progress_data=lua_result["result"].get("data"),
                    message=lua_result["result"]["message"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            else:
                return MCPResultMessage.error(
                    error_message=f"Unknown response status: {lua_result['status']}",
                    error_type="unknown_status",
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
                
        except Exception as e:
            logger.exception(f"Error executing function: {e}")
            return MCPResultMessage.error(
                error_message=f"Error executing function: {str(e)}",
                error_type="execution_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
    
    async def handle_query_state(self, payload: Dict[str, Any], message: MCPMessage) -> MCPMessage:
        """
        Handle a query_state command.
        
        Args:
            payload: Command payload
            message: Original MCP message
            
        Returns:
            Result message
        """
        if "query" not in payload:
            return MCPResultMessage.error(
                error_message="Missing query parameter",
                error_type="validation_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )
        
        query = payload["query"]
        options = payload.get("options", {})
        
        try:
            # Query state via the Lua client
            response = await self.lua_client.query_state(message.message_id)
            
            # Parse the response
            if isinstance(response, str):
                lua_result = ResultHandler.parse_response(response)
            else:
                lua_result = response
            
            # Format based on status (similar to other handlers)
            if lua_result["status"] == ResultType.SUCCESS.value:
                return MCPResultMessage.success(
                    result_data=lua_result["result"].get("data"),
                    message=lua_result["result"]["message"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            elif lua_result["status"] == ResultType.ERROR.value:
                return MCPResultMessage.error(
                    error_message=lua_result["result"]["message"],
                    error_data=lua_result["result"].get("data"),
                    error_type=lua_result["result"]["type"],
                    execution_time=lua_result.get("execution_time"),
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
            else:
                return MCPResultMessage.error(
                    error_message=f"Unknown response status: {lua_result['status']}",
                    error_type="unknown_status",
                    in_reply_to=message.message_id,
                    session_id=message.session_id
                )
                
        except Exception as e:
            logger.exception(f"Error querying state: {e}")
            return MCPResultMessage.error(
                error_message=f"Error querying state: {str(e)}",
                error_type="query_error",
                in_reply_to=message.message_id,
                session_id=message.session_id
            )