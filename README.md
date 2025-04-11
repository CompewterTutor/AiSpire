```
                                          
     .oo  o .oPYo.         o              
    .P 8    8                             
   .P  8 o8 `Yooo. .oPYo. o8 oPYo. .oPYo. 
  oPooo8  8     `8 8    8  8 8  `' 8oooo8 
 .P    8  8      8 8    8  8 8     8.     
.P     8  8 `YooP' 8YooP'  8 8     `Yooo' 
..:::::..:..:.....:8 ....::....:::::.....:
:::::::::::::::::::8 :::::::::::::::::::::
:::::::::::::::::::..:::::::::::::::::::::
```
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
- Utilize advanced Vectric SDK capabilities:
  - Matrix transformations for precise object manipulation
  - Specialized job types (two-sided, rotary)
  - Advanced toolpath strategies (V-carving, fluting, prism carving)
  - Tool database integration
  - Custom UI elements (HTML dialogs, progress bars)
  - External toolpath generation and import/export

## Project Status

AiSpire is currently in the early development phase. The architecture and technical specifications have been defined, but implementation has not yet begun.

## Directory Structure

- `lua_gadget/` - Lua plugin for Vectric software
- `python_mcp_server/` - Python implementation of MCP server
- `tests/` - Test files for both components
- `docs/` - Project documentation
  - `vectric_sdk/` - Contains detailed Vectric SDK reference documentation
- `llm_brain/` - AI development guidelines and project memory

## Getting Started

*Coming soon - Installation and usage instructions will be provided when the first functional version is available.*

## Requirements

- Vectric Aspire or V-Carve software
- Lua 5.3+ with LuaSocket library
- Python 3.8+ with required packages (see requirements.txt once available)
- Access to an LLM supporting the Model Context Protocol

## SDK Reference

The project includes a comprehensive Vectric SDK reference (located in `docs/vectric_sdk/Vectric.lua`) that documents the available functions for interacting with Vectric Aspire/V-Carve. This reference covers:

- Job creation and management
- Vector and geometry operations
- Toolpath generation with various strategies
- Tool database access
- User interface elements
- 3D component manipulation (Aspire only)
- System information and registry access

## Planned Enhancements

Based on the detailed SDK reference, we plan to implement:

1. **Advanced Geometric Operations**: Matrix-based transformations, complex path creation, and polar coordinate functions
2. **Specialized Job Management**: Support for two-sided and rotary jobs
3. **Comprehensive Toolpath Strategies**: Profile, pocket, V-carving, fluting, prism carving, 3D roughing and finishing
4. **Tool Database Integration**: Access system tool database, create custom tools
5. **UI Integration**: Custom dialogs, progress bars, file selection interfaces
6. **System Integration**: Application detection, file location access, registry settings
7. **External Toolpath Support**: Generate, import, and export custom toolpaths

## License

*License information to be determined*

## Contact

*Contact information to be provided*

