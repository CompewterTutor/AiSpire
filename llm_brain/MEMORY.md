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
- JSON parsing implementation completed for Lua component
  - Custom JSON encoder/decoder created for Lua
  - Comprehensive test suite implemented for JSON module
- Testing frameworks set up for both components
  - Lua: Busted framework configured with test runner
  - Python: pytest with asyncio support configured
- Helper functions for common operations implemented:
  - Path creation and manipulation (circles, rectangles, polygons)
  - Path combining using boolean operations
  - Path offsetting and scaling
  - Vector drawing (lines, arcs, curves, polylines)
  - Text creation and styling
  - Dimension and measurement tools
- No integration testing performed yet with actual Vectric software

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
- Custom JSON implementation for Lua to avoid dependencies
- Test-driven development approach for critical components
- Modular helper function design for reusability and maintainability
- Comprehensive test coverage for helper functions using mock objects

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
- SDK objects for vector manipulation identified:
  - Contour: For path creation and manipulation
  - Circle, Polyline, BezierCurve: For specific vector types
  - Text: For text creation and styling
  - Group: For organizing multiple objects
  - Transformation2D: For transforming objects

## Development Environment
- Need to set up:
  - Lua 5.3+ development environment with LuaSocket
  - Python 3.8+ environment with appropriate libraries
  - Testing frameworks for both components (Busted for Lua, pytest for Python)

## Current Challenges
- No official documentation for Vectric Lua SDK found yet, relying on SDK stubs
- Testing the Lua implementation without Vectric software requires mock SDK
- Need to implement full MCP protocol support in Python server
- Ensuring secure execution of arbitrary Lua code in production environment
- Creating realistic mock objects for testing helper functions

## Next Steps
1. Implement 3D model import and manipulation helpers
2. Create toolpath creation helper functions
3. Implement vector nesting capabilities
4. Add timeout mechanism for long-running Lua code execution
5. Implement logging with configurable levels
6. Create config file support for both components

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
- Create a comprehensive library of example operations for common CAD/CAM tasks
- Consider implementing a higher-level DSL for defining complex operations
- Investigate possible integration with other CAD/CAM formats and standards