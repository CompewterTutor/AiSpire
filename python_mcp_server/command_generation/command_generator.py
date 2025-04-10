"""
Command generator for creating Lua commands.
"""
from typing import Dict, Any, Optional, List, Tuple

from .template_engine import TemplateLibrary, LuaTemplate
from .command_validator import CommandValidator


class CommandGenerator:
    """Generates valid Lua commands for the Lua Gadget."""
    
    def __init__(self):
        """Initialize the command generator with a template library and validator."""
        self.template_library = TemplateLibrary()
        self.validator = CommandValidator()
    
    def generate_command(self, template_name: str, params: Dict[str, Any]) -> Tuple[bool, str, Optional[str]]:
        """
        Generate a command using a template and parameters.
        Returns (success, command_string, error_message) tuple.
        """
        template = self.template_library.get_template(template_name)
        if not template:
            return False, "", f"Template '{template_name}' not found"
        
        try:
            command = template.render(params)
            is_valid, error_message = self.validator.validate_command(command)
            if not is_valid:
                return False, "", error_message
            
            return True, command, None
        except Exception as e:
            return False, "", f"Error generating command: {str(e)}"
    
    def generate_custom_command(self, template_string: str, params: Dict[str, Any]) -> Tuple[bool, str, Optional[str]]:
        """
        Generate a command using a custom template string and parameters.
        Returns (success, command_string, error_message) tuple.
        """
        try:
            template = LuaTemplate(template_string)
            command = template.render(params)
            
            is_valid, error_message = self.validator.validate_command(command)
            if not is_valid:
                return False, "", error_message
            
            return True, command, None
        except Exception as e:
            return False, "", f"Error generating custom command: {str(e)}"
    
    def generate_raw_command(self, command: str) -> Tuple[bool, str, Optional[str]]:
        """
        Validate and return a raw Lua command.
        Returns (success, command_string, error_message) tuple.
        """
        is_valid, error_message = self.validator.validate_command(command)
        if not is_valid:
            return False, "", error_message
        
        return True, command, None
    
    def add_custom_template(self, name: str, template_string: str) -> Tuple[bool, Optional[str]]:
        """
        Add a custom template to the library.
        Returns (success, error_message) tuple.
        """
        try:
            self.template_library.add_template(name, template_string)
            return True, None
        except Exception as e:
            return False, f"Error adding template: {str(e)}"
    
    def list_available_templates(self) -> List[str]:
        """List all available templates in the library."""
        return self.template_library.list_templates()
