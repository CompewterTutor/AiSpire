"""
Result Handler for AiSpire.

This module processes and formats responses from the Lua Gadget
according to the MCP protocol specification.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import json
from enum import Enum
from typing import Any, Dict, Optional, Union


class ResultType(Enum):
    """Enumeration of possible result types."""
    SUCCESS = "success"
    ERROR = "error"
    IN_PROGRESS = "in_progress"
    INFO = "info"
    WARNING = "warning"


class ErrorCategory(Enum):
    """Enumeration of error categories for better classification."""
    SYNTAX = "syntax_error"
    RUNTIME = "runtime_error"
    CONNECTION = "connection_error"
    AUTHENTICATION = "authentication_error"
    PERMISSION = "permission_error"
    RESOURCE = "resource_error"
    TIMEOUT = "timeout_error"
    VALIDATION = "validation_error"
    UNKNOWN = "unknown_error"


class ResultHandler:
    """
    Handler for processing and formatting results from the Lua Gadget.
    Maps raw responses to structured MCP-compatible formats.
    """

    @staticmethod
    def parse_response(response_data: str) -> Dict[str, Any]:
        """
        Parse the raw response string from Lua Gadget.
        
        Args:
            response_data: Raw response string (JSON format)
            
        Returns:
            Parsed response as a dictionary
        
        Raises:
            ValueError: If the response cannot be parsed as valid JSON
        """
        try:
            return json.loads(response_data)
        except json.JSONDecodeError:
            return {
                "status": ResultType.ERROR.value,
                "result": {
                    "message": f"Invalid JSON response: {response_data}",
                    "type": ErrorCategory.SYNTAX.value,
                    "data": None
                }
            }

    @staticmethod
    def process_lua_response(response: Dict[str, Any], command_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Process a response received from the Lua Gadget and format according to MCP protocol.
        
        Args:
            response: The raw response dictionary from Lua Gadget
            command_id: Original command identifier
            
        Returns:
            MCP-formatted response
        """
        # This is a stub implementation - in the actual code this would be more complex
        status = response.get("status", "")
        result = response.get("result", {})
        
        if isinstance(result, str):
            # Handle case where result is a string
            result = {"message": result, "data": None}
            
        return {
            "status": status,
            "result": result,
            "command_id": command_id or response.get("command_id"),
            "execution_time": response.get("execution_time")
        }
