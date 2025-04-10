"""
Result handler module for processing responses from the Lua Gadget.
This module handles different types of responses and formats them according to MCP protocol.
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
    def format_success_response(data: Any, message: str = "Operation completed successfully", 
                               command_id: Optional[str] = None, execution_time: Optional[int] = None) -> Dict[str, Any]:
        """
        Format a success response according to MCP protocol.
        
        Args:
            data: The result data
            message: A human-readable success message
            command_id: The original command identifier
            execution_time: Execution time in milliseconds
            
        Returns:
            Formatted success response
        """
        return {
            "status": ResultType.SUCCESS.value,
            "result": {
                "data": data,
                "message": message,
                "type": "result"
            },
            "command_id": command_id,
            "execution_time": execution_time
        }

    @staticmethod
    def format_error_response(message: str, category: ErrorCategory = ErrorCategory.UNKNOWN, 
                             data: Any = None, command_id: Optional[str] = None,
                             execution_time: Optional[int] = None) -> Dict[str, Any]:
        """
        Format an error response according to MCP protocol.
        
        Args:
            message: Error message
            category: Error category for classification
            data: Additional error data if available
            command_id: The original command identifier
            execution_time: Execution time in milliseconds
            
        Returns:
            Formatted error response
        """
        return {
            "status": ResultType.ERROR.value,
            "result": {
                "message": message,
                "type": category.value,
                "data": data
            },
            "command_id": command_id,
            "execution_time": execution_time
        }

    @staticmethod
    def format_in_progress_response(progress: float, message: str = "Operation in progress", 
                                  command_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Format an in-progress response according to MCP protocol.
        
        Args:
            progress: Progress percentage (0.0 to 1.0)
            message: Status message
            command_id: The original command identifier
            
        Returns:
            Formatted in-progress response
        """
        return {
            "status": ResultType.IN_PROGRESS.value,
            "result": {
                "data": {"progress": progress},
                "message": message,
                "type": "progress"
            },
            "command_id": command_id,
            "execution_time": None
        }

    @staticmethod
    def format_info_response(message: str, data: Any = None, 
                           command_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Format an informational response according to MCP protocol.
        
        Args:
            message: Informational message
            data: Additional information data
            command_id: The original command identifier
            
        Returns:
            Formatted info response
        """
        return {
            "status": ResultType.INFO.value,
            "result": {
                "message": message,
                "type": "info",
                "data": data
            },
            "command_id": command_id,
            "execution_time": None
        }

    @staticmethod
    def format_warning_response(message: str, data: Any = None, 
                              command_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Format a warning response according to MCP protocol.
        
        Args:
            message: Warning message
            data: Additional warning data
            command_id: The original command identifier
            
        Returns:
            Formatted warning response
        """
        return {
            "status": ResultType.WARNING.value,
            "result": {
                "message": message,
                "type": "warning",
                "data": data
            },
            "command_id": command_id,
            "execution_time": None
        }

    @classmethod
    def categorize_error(cls, error_message: str) -> ErrorCategory:
        """
        Categorize an error based on the error message.
        
        Args:
            error_message: The error message to categorize
            
        Returns:
            Appropriate error category
        """
        error_message = error_message.lower()
        
        if any(kw in error_message for kw in ["syntax", "unexpected", "expected", "parse"]):
            return ErrorCategory.SYNTAX
        elif any(kw in error_message for kw in ["connection", "connect", "socket", "network"]):
            return ErrorCategory.CONNECTION
        elif any(kw in error_message for kw in ["auth", "permission", "denied", "unauthorized"]):
            return ErrorCategory.PERMISSION
        elif any(kw in error_message for kw in ["timeout", "timed out"]):
            return ErrorCategory.TIMEOUT
        elif any(kw in error_message for kw in ["valid", "invalid", "argument"]):
            return ErrorCategory.VALIDATION
        elif any(kw in error_message for kw in ["memory", "resource", "capacity"]):
            return ErrorCategory.RESOURCE
        elif any(kw in error_message for kw in ["runtime", "error", "exception", "nil", "null"]):
            return ErrorCategory.RUNTIME
        else:
            return ErrorCategory.UNKNOWN

    @classmethod
    def process_lua_response(cls, response: Dict[str, Any], command_id: Optional[str] = None) -> Dict[str, Any]:
        """
        Process a response received from the Lua Gadget and format according to MCP protocol.
        
        Args:
            response: The raw response dictionary from Lua Gadget
            command_id: Original command identifier
            
        Returns:
            MCP-formatted response
        """
        status = response.get("status", "")
        result = response.get("result", {})
        execution_time = response.get("execution_time")
        
        if status == "success":
            return cls.format_success_response(
                data=result.get("data"),
                message=result.get("message", "Operation completed successfully"),
                command_id=command_id or response.get("command_id"),
                execution_time=execution_time
            )
        elif status == "error":
            error_message = result.get("message", "Unknown error occurred")
            error_type = result.get("type")
            
            # If error_type is provided, use it; otherwise, categorize based on message
            if error_type and any(error_type == e.value for e in ErrorCategory):
                category = next((e for e in ErrorCategory if e.value == error_type), ErrorCategory.UNKNOWN)
            else:
                category = cls.categorize_error(error_message)
                
            return cls.format_error_response(
                message=error_message,
                category=category,
                data=result.get("data"),
                command_id=command_id or response.get("command_id"),
                execution_time=execution_time
            )
        elif status == "in_progress":
            progress_data = result.get("data", {})
            progress = progress_data.get("progress", 0.0) if isinstance(progress_data, dict) else 0.0
            
            return cls.format_in_progress_response(
                progress=progress,
                message=result.get("message", "Operation in progress"),
                command_id=command_id or response.get("command_id")
            )
        else:
            # Unknown status, treat as error
            return cls.format_error_response(
                message=f"Unknown response status: {status}",
                category=ErrorCategory.UNKNOWN,
                data=response,
                command_id=command_id or response.get("command_id")
            )
