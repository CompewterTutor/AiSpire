# AiSpire Project Memory

## Project Overview
AiSpire is an MCP Server and plugin for Vectric Aspire/V-Carve (CAD/CAM Software). The system consists of a Lua "Gadget" that runs a socket server inside V-Carve with access to the Lua Gadget SDK, and a Python MCP Server that connects to it, enabling control by LLMs.

## Current Project State
- Initial project planning phase
- Technical guidelines established
- TODO list created
- Project structure defined

## Technical Decisions
- Two-component architecture: Lua Gadget and Python MCP Server
- Socket-based communication between components
- MCP protocol for LLM integration

## Research Notes
- Need to thoroughly review Vectric Aspire/V-Carve Lua SDK documentation
- Need to identify required MCP protocol specifications
- Consider security implications of executing arbitrary Lua code

## Development Environment
- Not yet established

## Current Challenges
- Understanding the extent and limitations of the Vectric Lua SDK
- Implementing secure execution of arbitrary Lua code
- Designing an effective command structure between Python and Lua components

## Next Steps
- Begin setting up the project directory structure
- Research Vectric Aspire/V-Carve SDK documentation
- Set up development environments for both Lua and Python

## Resources
- Need to locate official Vectric Aspire/V-Carve SDK documentation
- Need to review MCP protocol specifications

## Notes for Future Development
- Consider how to handle different versions of Vectric software
- Plan for testing without requiring actual Vectric software installation
- Think about how to provide visual feedback from operations performed in Vectric