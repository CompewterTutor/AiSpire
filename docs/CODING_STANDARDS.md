# AiSpire Coding Standards

This document outlines the coding standards and best practices for the AiSpire project across both Lua and Python components.

## General Guidelines

- Use descriptive variable and function names
- Include comments for complex logic
- Write modular, reusable code
- Add appropriate error handling
- Include unit tests for all functionality
- Keep functions focused and relatively small (< 50 lines when possible)
- Document public APIs and interfaces

## Lua Coding Standards

### Style Guide

- Use camelCase for variable names and function names
- Use PascalCase for class/object names
- Use snake_case for file names
- Indent with 2 spaces (not tabs)
- Limit line length to 80 characters when possible
- Use local variables whenever possible
- Add spaces around operators and after commas

### Example

```lua
-- Good practice example
local function calculateToolpathLength(contour, tool)
  local length = 0
  
  if not contour or not tool then
    return 0
  end
  
  -- Calculate length based on contour points
  for i = 1, #contour - 1 do
    local point1 = contour[i]
    local point2 = contour[i + 1]
    length = length + getDistance(point1, point2)
  end
  
  return length
end
```

## Python Coding Standards

### Style Guide

- Follow PEP 8 style guidelines
- Use snake_case for variable names, function names, and module names
- Use PascalCase for class names
- Use UPPER_CASE for constants
- Use 4 spaces for indentation (not tabs)
- Limit line length to 88 characters (compatible with Black formatter)
- Use type hints for all function parameters and return values
- Use docstrings for all modules, classes, and functions

### Example

```python
def calculate_toolpath_length(contour: List[Point], tool: Tool) -> float:
    """
    Calculate the total length of a toolpath based on the contour points.
    
    Args:
        contour: A list of Point objects representing the toolpath
        tool: The Tool object being used for the operation
        
    Returns:
        The total length of the toolpath in the current unit system
        
    Raises:
        ValueError: If contour is empty or None
    """
    if not contour or len(contour) < 2:
        raise ValueError("Contour must contain at least two points")
        
    length = 0.0
    for i in range(len(contour) - 1):
        point1 = contour[i]
        point2 = contour[i + 1]
        length += get_distance(point1, point2)
        
    return length
```

## Documentation Standards

- Use JSDoc style comments for Lua functions
- Use Google-style docstrings for Python code
- Document all parameters, return values, and exceptions
- Include examples for complex functions
- Keep API documentation up-to-date with code changes

## Testing Standards

### Lua Tests

- Use Busted framework for Lua tests
- Create tests for each module in a corresponding test file
- Include tests for edge cases and error conditions
- Mock external dependencies when necessary

### Python Tests

- Use pytest for Python tests
- Aim for at least 80% code coverage
- Use fixtures for common test setups
- Include unit tests, integration tests, and end-to-end tests
- Use mocking for external dependencies

## Version Control Practices

- Use meaningful commit messages
- Keep commits focused on a single task or fix
- Regularly pull changes from the main branch
- Create feature branches for new development
- Use pull requests for code review before merging
- Tag releases with version numbers

## Continuous Integration

- Run all tests before committing code
- Use automated CI pipelines when available
- Run linters as part of the CI process
- Verify documentation builds correctly

## Security Best Practices

- Validate all user inputs
- Use secure authentication mechanisms
- Avoid storing sensitive data in code
- Use environment variables for configuration
- Implement proper error handling that doesn't expose internal details
- Keep dependencies updated