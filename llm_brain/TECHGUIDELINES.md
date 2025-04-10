# Technical Guidelines for AiSpire

## Architecture Overview

AiSpire consists of two main components:

1. **Lua Gadget Plugin**: A Lua script that runs within Vectric Aspire/V-Carve and exposes a socket server
2. **Python MCP Server**: A Model Context Protocol server that connects to the Lua socket server and enables LLM interaction

```
┌─────────────┐         ┌───────────────┐         ┌────────┐
│ LLM Service │◄───────►│ Python        │◄───────►│ Vectric │
│             │         │ MCP Server    │         │ Aspire │
└─────────────┘         └───────────────┘         │ (Lua   │
                                                  │ Gadget)│
                                                  └────────┘
```

## Lua Gadget Component

### Technical Requirements

- Socket server implementation in Lua
- Integration with Vectric Aspire/V-Carve Lua SDK
- Command parsing and execution
- Status reporting back to the Python MCP server

### Features to Implement

1. **Socket Server**
   - Create a TCP socket server on a configurable port
   - Handle connections from the Python MCP server
   - Support multiple command formats (JSON, plain text)
   - Implement basic error handling and recovery

2. **Vectric SDK Interface**
   - Create wrapper functions for common Vectric SDK operations
   - Implement sandbox for executing arbitrary Lua code safely
   - Create helper functions for common operations

3. **Command Interface**
   - Parse and validate incoming commands
   - Execute commands using the Vectric SDK
   - Return results and status information
   - Support asynchronous operations where applicable

4. **Error Handling & Logging**
   - Implement robust error handling
   - Create detailed logging
   - Support different verbosity levels

### Additional Lua Features to Consider

- Persistent session handling
- Command history tracking
- State management for complex operations
- Undo/redo functionality
- File system access for importing/exporting files
- Image processing capabilities

## Python MCP Server Component

### Technical Requirements

- Model Context Protocol (MCP) server implementation
- Socket client to communicate with the Lua gadget
- Command generation and result interpretation
- LLM integration

### Features to Implement

1. **MCP Server**
   - Implement the MCP protocol specification
   - Handle requests from LLM clients
   - Translate LLM requests into Vectric commands

2. **Socket Client**
   - Connect to the Lua gadget socket server
   - Send commands and receive responses
   - Handle connection errors and retries

3. **Command Processing**
   - Convert natural language or structured commands to Lua code
   - Parse and interpret responses from the Lua gadget
   - Format responses for the LLM client

4. **LLM Integration**
   - Implement necessary handlers for LLM communication
   - Provide context and history to the LLM
   - Process LLM responses

### Additional Python Features to Consider

- Command templating system
- User authentication and permissions
- Web UI for monitoring and direct interaction
- Result visualization
- Project management
- Version control integration

## Data Flow

1. LLM client sends request to Python MCP server
2. MCP server processes request and generates Vectric commands
3. Commands are sent to Lua gadget via socket connection
4. Lua gadget executes commands using Vectric SDK
5. Results are sent back to MCP server
6. MCP server formats results for LLM client
7. Results are returned to LLM client

## Security Considerations

- Validate all input from LLM clients
- Limit Lua execution capabilities to prevent harmful operations
- Implement authentication for the socket connection
- Consider encryption for sensitive data
- Rate limiting to prevent abuse

## Testing Strategy

- Unit tests for both Python and Lua components
- Integration tests for the full system
- Mock Vectric SDK for testing without the actual software
- Scenario-based testing for common use cases

## Performance Considerations

- Optimize socket communication
- Batch commands when possible
- Consider caching frequently used operations
- Monitor and log performance metrics