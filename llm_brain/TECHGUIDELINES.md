# AiSpire Technical Guidelines

## System Architecture

### Overview
AiSpire consists of two primary components:
1. **Lua Gadget** - A plugin for Vectric Aspire/V-Carve that runs inside the CAD/CAM environment
2. **Python MCP Server** - A server implementing the Model Context Protocol for LLM integration

```
                 ┌─────────────┐            ┌─────────────┐            ┌─────────┐
                 │             │            │             │            │         │
                 │    LLMs     │◄─────────► │ Python MCP  │◄─────────► │   Lua   │
                 │             │   (MCP)    │   Server    │  (Socket)  │ Gadget  │
                 │             │            │             │            │         │
                 └─────────────┘            └─────────────┘            └─────────┘
                                                                           │
                                                                           │
                                                                           ▼
                                                                      ┌─────────────┐
                                                                      │  Vectric    │
                                                                      │ Aspire/     │
                                                                      │  V-Carve    │
                                                                      └─────────────┘
```

### Communication Flow
1. LLMs send commands to the MCP Server
2. MCP Server translates commands into Lua code
3. Lua code is sent to the Lua Gadget via socket connection
4. Lua Gadget executes the code using the Vectric SDK
5. Results are sent back through the same channels

## Lua Gadget Technical Guidelines
- Refer to docs/vectric_sdk/Vectric.lua for SDK reference
### Socket Server
- Use Lua socket library
- Create a TCP server listening on a configurable port (default: 9876)
- Accept connections from localhost only for security
- Implement basic authentication via shared secret
- Maintain a persistent connection with the MCP Server

### Command Execution
- Receive Lua code snippets or command strings
- Parse commands to identify operation type
- Execute commands using the Vectric SDK
- Capture errors and execution results
- Return structured responses (JSON format)

### SDK Wrapper
- Create wrapper functions around core Vectric SDK functionality
- Implement safety checks before executing potentially destructive operations
- Provide simplified interfaces for common operations
- Support execution history and operation reversal (undo)

### Safety Measures
- Validate all incoming commands
- Implement timeout for long-running operations
- Add emergency stop functionality
- Create sandbox for arbitrary Lua code execution

### Documentation
- Document all available commands
- Include example usage and expected outputs
- Provide troubleshooting guides for common issues

## Python MCP Server Technical Guidelines

### Socket Client
- Establish and maintain connection to Lua Gadget
- Implement auto-reconnect functionality
- Handle connection timeouts and errors
- Support secure communication

### MCP Protocol Implementation
- Follow Model Context Protocol specification
- Support required message types and extensions
- Implement proper error handling and response formatting
- Add custom extensions for CAD/CAM specific operations

### Command Generation
- Create a command builder for generating valid Lua code
- Implement templates for common operations
- Support command chaining and sequences
- Add validation before sending commands

### Result Processing
- Parse JSON responses from Lua Gadget
- Format results according to MCP specifications
- Include visual feedback where possible (e.g., image URLs)
- Support streaming results for long-running operations

### Security
- Implement authentication and authorization mechanisms
- Validate LLM requests against allowed operations
- Log all operations for audit purposes
- Support user-based access controls

## Communication Protocol

### Command Format
```json
{
  "command_type": "execute_code | execute_function | query_state",
  "payload": {
    "code": "string containing Lua code (for execute_code)",
    "function": "function name (for execute_function)",
    "parameters": {}, 
    "options": {}
  },
  "id": "unique command identifier",
  "auth": "authentication token"
}
```

### Response Format
```json
{
  "status": "success | error | in_progress",
  "result": {
    "data": {},
    "message": "human readable message",
    "type": "result type identifier"
  },
  "command_id": "original command identifier",
  "execution_time": "time in ms"
}
```

## Supported Operations

Based on the available Vectric SDK (as documented in docs/vectric_sdk/Vectric.lua), AiSpire will support the following operations:

### Job Management
- Create, open, save, and export jobs (using CreateNewJob, OpenExistingJob, SaveCurrentJob)
- Create specialized job types (2-sided jobs, rotary jobs)
- Modify job properties
- Manage material settings through MaterialBlock object

### Vector Operations
- Create and modify geometric primitives (lines, arcs, circles, beziers)
- Draw complex paths and contours using the Contour and ContourGroup objects
- Use spans (LineSpan, ArcSpan, BezierSpan) for path construction
- Import/export vector data
- Transform vectors using Matrix2D operations (scale, rotate, translate, reflect)
- Manipulate vector objects (CadContour, CadPolyline, CadObjectGroup)
- Work with 2D and 3D points (Point2D, Point3D) and vectors (Vector2D, Vector3D)
- Handle bounding boxes and regions (Box2D)

### Layer Management
- Create and modify layers
- Change layer visibility and properties
- Move objects between layers

### Toolpath Operations
- Create and calculate various toolpath types:
  - Profile toolpaths (ProfileParameterData)
  - Pocket toolpaths (CreatePocketingToolpath)
  - Drilling operations (CreateDrillingToolpath)
  - V-carving toolpaths (CreateVCarvingToolpath)
  - Fluting toolpaths (CreateFlutingToolpath)
  - Prism carving toolpaths (CreatePrismCarvingToolpath)
  - 3D roughing toolpaths (CreateRoughingToolpath)
  - 3D finishing toolpaths (CreateFinishingToolpath)
- Set toolpath parameters through specialized parameter data objects
- Preview and simulate toolpaths
- Add lead-in/lead-out and ramping capabilities
- Export toolpath files using ToolpathSaver
- Access tool database to manage and select tools

### 3D Modeling (Aspire-specific)
- Import 3D models
- Create basic 3D shapes
- Modify 3D model properties
- Work with components and component groups

### UI Operations
- Create custom dialogs using HTML_Dialog
- Display messages to users through DisplayMessageBox/MessageBox
- Create file selection dialogs (FileDialog)
- Show progress bars for long-running operations (ProgressBar)
- Get user input and selections

### System Operations
- Access application information (GetAppVersion, GetBuildVersion)
- Check application type (IsAspire, IsBetaBuild)
- Get file locations (GetDataLocation, GetToolDatabaseLocation, etc.)
- Access and modify registry settings

## Development Guidelines

### Lua Component
- Follow Lua programming best practices
- Thoroughly test SDK function wrappers
- Document all functions with proper JSDoc-style comments
- Handle errors gracefully and provide meaningful error messages
- Implement logging with configurable verbosity

### Python Component
- Use Python 3.8+ 
- Follow PEP 8 style guidelines
- Use type hints for all functions
- Implement comprehensive unit tests
- Document API with standard docstrings
- Use asynchronous programming where appropriate

### Error Handling
- Implement proper error trapping in both components
- Return structured error messages
- Include error codes and suggested fixes
- Log errors with appropriate detail for troubleshooting

### Testing
- Create unit tests for both Lua and Python components
- Implement integration tests for the complete system
- Create a mock Vectric SDK for testing without the actual software
- Test with real Vectric software for final validation

### Performance
- Optimize for low latency in command execution
- Implement request queuing for concurrent operations
- Support command batching for efficiency
- Monitor resource usage and implement limits

## Deployment

### Lua Gadget Installation
- Package as a standard Vectric Gadget (.lua file)
- Include installation instructions
- Support multiple Vectric software versions

### Python Server Deployment
- Package as a standard Python package
- Support installation via pip
- Include Docker deployment option
- Document required dependencies and environment setup

## Future Considerations
- Web UI for direct interactions
- Support for additional CAD/CAM software
- Plugin system for extending functionality
- Integration with version control systems for designs
- Collaborative design features