"""
Command Templates for the Vectric environment.

This package provides templates for generating Lua code to perform
common operations in the Vectric environment.
"""

from python_mcp_server.command_generation.templates.job_templates import JobTemplates
from python_mcp_server.command_generation.templates.vector_templates import VectorTemplates
from python_mcp_server.command_generation.templates.toolpath_templates import ToolpathTemplates
from python_mcp_server.command_generation.templates.layer_templates import LayerTemplates

__all__ = [
    'JobTemplates',
    'VectorTemplates', 
    'ToolpathTemplates',
    'LayerTemplates'
]