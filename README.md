# AiSpire

AiSpire is an intelligent interface for Vectric Aspire and V-Carve CAD/CAM software that enables AI-powered design and machining capabilities.

## Overview

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

## Features

- Execute arbitrary Lua code inside Vectric software
- Create and manipulate vector paths programmatically
- Import and modify 3D models
- Draw vector shapes and text
- Optimize vector nesting for material utilization
- Generate and calculate toolpaths for CNC machining

## Project Status

AiSpire is currently in the early development phase. The architecture and technical specifications have been defined, but implementation has not yet begun.

## Directory Structure

- `lua_gadget/` - Lua plugin for Vectric software
- `python_mcp_server/` - Python implementation of MCP server
- `tests/` - Test files for both components
- `docs/` - Project documentation
- `llm_brain/` - AI development guidelines and project memory

## Getting Started

*Coming soon - Installation and usage instructions will be provided when the first functional version is available.*

## Requirements

- Vectric Aspire or V-Carve software
- Lua 5.3+ with LuaSocket library
- Python 3.8+ with required packages (see requirements.txt once available)
- Access to an LLM supporting the Model Context Protocol

## License

*License information to be determined*

## Contact

*Contact information to be provided*

