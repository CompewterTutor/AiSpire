"""
Model Context Protocol (MCP) package for AiSpire.

This package provides functionality for implementing the Model Context Protocol
for communication with LLMs and integrating with the Vectric Lua Gadget.
"""

from .protocol import (
    MCPMessage,
    MCPMessageType, 
    MCPContentType,
    MCPProtocolError,
    MCPCommandMessage,
    MCPResultMessage,
    MCPSession,
    MCPProcessor
)

__all__ = [
    'MCPMessage',
    'MCPMessageType',
    'MCPContentType',
    'MCPProtocolError',
    'MCPCommandMessage',
    'MCPResultMessage',
    'MCPSession',
    'MCPProcessor'
]
