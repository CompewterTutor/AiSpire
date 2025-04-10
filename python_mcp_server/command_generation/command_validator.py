"""
Validator for Lua commands before sending to the Lua Gadget.
"""
import re
from typing import Dict, Any, List, Tuple, Optional


class CommandValidator:
    """Validates Lua commands for syntax and potential security issues."""
    
    # Patterns to detect potentially harmful operations
    HARMFUL_PATTERNS = [
        r'os\.execute',  # OS command execution
        r'io\.[^:]*file',  # File operations
        r'loadfile',  # Loading files
        r'dofile',  # Executing files
        r'package\.loadlib',  # Loading libraries
        r'require',  # Requiring modules that might not be safe
    ]
    
    def __init__(self):
        """Initialize the command validator."""
        self._compiled_patterns = [re.compile(pattern) for pattern in self.HARMFUL_PATTERNS]
    
    def validate_lua_syntax(self, code: str) -> Tuple[bool, Optional[str]]:
        """
        Basic validation of Lua syntax.
        Returns (is_valid, error_message) tuple.
        """
        # Check for balanced brackets, parentheses, and string literals
        stack = []
        in_string = None
        in_comment = False
        line_num = 1
        col_num = 0
        
        for i, char in enumerate(code):
            col_num += 1
            
            # Track line numbers
            if char == '\n':
                line_num += 1
                col_num = 0
                in_comment = False
                continue
            
            # Skip comments
            if in_comment:
                continue
                
            if in_string is None:
                # Check for comment start
                if char == '-' and i+1 < len(code) and code[i+1] == '-':
                    in_comment = True
                    continue
                
                # Check for string start
                elif char in ['"', "'"]:
                    in_string = char
                
                # Check for opening brackets
                elif char in ['(', '[', '{']:
                    stack.append((char, line_num, col_num))
                
                # Check for closing brackets
                elif char in [')', ']', '}']:
                    if not stack:
                        return False, f"Unmatched closing bracket '{char}' at line {line_num}, column {col_num}"
                    
                    opening, open_line, open_col = stack.pop()
                    if (opening == '(' and char != ')') or \
                       (opening == '[' and char != ']') or \
                       (opening == '{' and char != '}'):
                        return False, f"Mismatched brackets: '{opening}' at line {open_line}, column {open_col} and '{char}' at line {line_num}, column {col_num}"
            
            # Check for string end
            elif char == in_string:
                # Check if it's an escaped quote
                if i > 0 and code[i-1] == '\\':
                    # Check if the backslash itself is escaped
                    if i > 1 and code[i-2] == '\\':
                        in_string = None
                else:
                    in_string = None
        
        # Check for unclosed strings
        if in_string is not None:
            return False, f"Unclosed string starting with {in_string}"
        
        # Check for unclosed brackets
        if stack:
            opening, line, col = stack[-1]
            return False, f"Unclosed bracket '{opening}' at line {line}, column {col}"
        
        return True, None
    
    def check_for_harmful_operations(self, code: str) -> Tuple[bool, Optional[str]]:
        """
        Check for potentially harmful operations in Lua code.
        Returns (is_safe, error_message) tuple.
        """
        for pattern in self._compiled_patterns:
            match = pattern.search(code)
            if match:
                return False, f"Potentially harmful operation found: '{match.group(0)}'"
        
        return True, None
    
    def validate_parameters(self, params: Dict[str, Any], required_params: List[str],
                           param_types: Dict[str, type] = None) -> Tuple[bool, Optional[str]]:
        """
        Validate command parameters against required parameters and types.
        Returns (is_valid, error_message) tuple.
        """
        # Check for missing required parameters
        for param in required_params:
            if param not in params:
                return False, f"Missing required parameter: {param}"
        
        # Check parameter types if specified
        if param_types:
            for param, value in params.items():
                if param in param_types and not isinstance(value, param_types[param]):
                    expected_type = param_types[param].__name__
                    actual_type = type(value).__name__
                    return False, f"Invalid type for parameter '{param}': expected {expected_type}, got {actual_type}"
        
        return True, None
    
    def validate_command(self, code: str, params: Dict[str, Any] = None,
                        required_params: List[str] = None,
                        param_types: Dict[str, type] = None) -> Tuple[bool, Optional[str]]:
        """
        Complete validation of a command.
        Returns (is_valid, error_message) tuple.
        """
        # Validate Lua syntax
        is_valid, error_message = self.validate_lua_syntax(code)
        if not is_valid:
            return False, error_message
        
        # Check for harmful operations
        is_safe, error_message = self.check_for_harmful_operations(code)
        if not is_safe:
            return False, error_message
        
        # Validate parameters if provided
        if params and required_params:
            is_valid, error_message = self.validate_parameters(
                params, required_params, param_types
            )
            if not is_valid:
                return False, error_message
        
        return True, None
