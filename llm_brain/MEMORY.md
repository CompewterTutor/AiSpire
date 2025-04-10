# AiSpire Project Memory

## Project Overview
AiSpire is an MCP Server and plugin for Vectric Aspire/V-Carve (CAD/CAM Software). The system consists of a Lua "Gadget" that runs a socket server inside V-Carve with access to the Lua Gadget SDK, and a Python MCP Server that connects to it, enabling control by LLMs.

## Current Project State
- Initial project setup completed
  - Directory structure created with main folders for both components
  - Basic README.md created with project overview, architecture, and features
  - .gitignore file created for Lua and Python development
  - Coding standards document established in docs/CODING_STANDARDS.md
- Initial implementation of both components started:
  - Lua Gadget: Basic socket server with command processing framework
  - Python MCP Server: Basic server structure with Lua client implementation
- Project architecture defined with two main components: Lua Gadget and Python MCP Server
- Communication protocol between components designed using JSON message format
- No integration testing performed yet

## Technical Decisions
- Two-component architecture: Lua Gadget and Python MCP Server
- Socket-based communication between components using TCP
- JSON message format for commands and responses
- MCP protocol for LLM integration
- Default port: 9876 for socket communication between Lua and Python
- Default port: 8765 for MCP server communication with LLMs
- Authentication via shared secret tokens for security
- Sandbox environment for executing Lua code securely
- Configuration management via environment variables and config files

## Research Notes
- Vectric Aspire/V-Carve Lua SDK offers extensive functionality:
  - Job management (create, open, save, export)
  - Vector operations (create/modify geometric primitives)
  - Layer management
  - Toolpath operations
  - 3D modeling capabilities
  - UI operations (dialogs, messages)
- Lua socket implementation using LuaSocket library
- MCP protocol implementation in Python
- Detailed SDK stubs from vectric_lua_sdk_stubs.lua available for reference

## Development Environment
- Need to set up:
  - Lua 5.3+ development environment with LuaSocket
  - Python 3.8+ environment with appropriate libraries
  - Testing frameworks for both components (Busted for Lua, pytest for Python)

## Current Challenges
- No official documentation for Vectric Lua SDK found yet, relying on SDK stubs
- Need to implement proper JSON parsing in Lua (currently using placeholder functions)
- Need to implement full MCP protocol support in Python server
- Testing without Vectric software will require mock SDK implementation

## Next Steps
1. Complete implementation of Lua Gadget socket server
2. Add proper JSON parsing to Lua component
3. Implement Vectric SDK wrapper functions in Lua
4. Enhance Python MCP Server with full protocol support
5. Create testing framework for both components
6. Begin implementing unit tests

## Resources
- SDK stubs from vectric_lua_sdk_stubs.lua
- Need to locate official Vectric Aspire/V-Carve SDK documentation
- Need to review MCP protocol specifications

## Notes for Future Development
- Consider implementing a command history system for undoing operations
- Plan for visualization of results from Python side
- Design should allow for future web UI integration
- Consider security implications of executing arbitrary Lua code
- Plan for testing without requiring actual Vectric software installation