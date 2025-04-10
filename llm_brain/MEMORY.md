# AiSpire Project Memory

## Project Overview
AiSpire is an MCP Server and plugin for Vectric Aspire/V-Carve (CAD/CAM Software). The system consists of a Lua "Gadget" that runs a socket server inside V-Carve with access to the Lua Gadget SDK, and a Python MCP Server that connects to it, enabling control by LLMs.

## Current Project State
- Planning phase completed with detailed technical guidelines
- Comprehensive TODO list created with granular tasks
- Project architecture defined with two main components: Lua Gadget and Python MCP Server
- Communication protocol between components designed
- No code implementation started yet

## Technical Decisions
- Two-component architecture: Lua Gadget and Python MCP Server
- Socket-based communication between components using TCP
- JSON message format for commands and responses
- MCP protocol for LLM integration
- Default port: 9876 for socket communication
- Authentication via shared secret for security

## Research Notes
- Vectric Aspire/V-Carve Lua SDK offers extensive functionality:
  - Job management (create, open, save, export)
  - Vector operations (create/modify geometric primitives)
  - Layer management
  - Toolpath operations
  - 3D modeling capabilities
  - UI operations (dialogs, messages)
- Need to further research Lua socket implementation details
- Need to research MCP protocol specifications

## Development Environment
- Need to set up:
  - Lua 5.3+ development environment with LuaSocket
  - Python 3.8+ environment with appropriate libraries
  - Testing frameworks for both components

## Current Challenges
- No official documentation for Vectric Lua SDK found yet, relying on SDK stubs
- Need to implement secure execution of arbitrary Lua code within sandbox
- Need to design an effective command structure between Python and Lua components
- Testing without Vectric software will require mock SDK implementation

## Next Steps
1. Set up project directory structure
2. Create initial README.md
3. Set up version control and .gitignore
4. Research more on Vectric SDK and MCP protocol
5. Begin implementing basic structure of both components

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