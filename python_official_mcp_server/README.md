# AiSpire Official MCP Server

This directory contains the implementation of the AiSpire MCP server using the official Model Context Protocol (MCP) Python SDK.

## Overview

The Model Context Protocol (MCP) is a standardized protocol for communication between Large Language Models (LLMs) and external tools. This implementation uses the official MCP Python SDK to create a server that integrates with the AiSpire Lua Gadget, providing a standardized interface for LLMs to control Vectric Aspire/V-Carve applications.

## Features

- **Official MCP SDK Integration**: Built using the official MCP Python SDK for full protocol compliance
- **Comprehensive Tool Support**: Includes tools for Lua code execution, vector creation, and toolpath generation
- **Resource Exposure**: Exposes Vectric job data as MCP resources
- **Metrics Collection**: Integrates with existing metrics system for monitoring server performance
- **Configuration System**: Uses the same configuration system as the custom MCP server implementation
- **Client Examples**: Includes examples of how to use the server with the MCP client SDK

## Installation

The server requires Python 3.8+ and the MCP Python SDK. Install the requirements with:

```bash
pip install mcp
```

## Usage

### Starting the Server

To start the server, run:

```bash
python run_server.py
```

You can configure the server with command line arguments:

```bash
python run_server.py --host localhost --port 8765 --lua-host localhost --lua-port 9876 --log-level DEBUG
```

Or use environment variables:

```bash
AISPIRE_MCP_HOST=localhost AISPIRE_MCP_PORT=8765 AISPIRE_LUA_HOST=localhost AISPIRE_LUA_PORT=9876 python run_server.py
```

### Configuration

The server uses the same configuration system as the custom MCP server. You can configure it using:

1. Default configuration values
2. Configuration file (JSON)
3. Environment variables

#### Environment Variables

- `AISPIRE_MCP_HOST`: Host for the MCP server to bind to
- `AISPIRE_MCP_PORT`: Port for the MCP server to bind to
- `AISPIRE_LUA_HOST`: Host of the Lua Gadget
- `AISPIRE_LUA_PORT`: Port of the Lua Gadget
- `AISPIRE_LUA_AUTH_TOKEN`: Auth token for the Lua Gadget
- `AISPIRE_LOG_LEVEL`: Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)

### Available Tools

The server provides the following tools:

#### `execute_code`

Execute raw Lua code in the Vectric environment.

**Parameters:**
- `code` (string): Lua code to execute

**Example:**
```python
result = await session.execute_tool("execute_code", {
    "code": "return Job.GetName()"
})
```

#### `query_state`

Query the current state of the Vectric environment.

**Parameters:** None

**Example:**
```python
state = await session.execute_tool("query_state", {})
```

#### `create_vector`

Create a vector in the Vectric environment.

**Parameters:**
- `vector_type` (string): Type of vector (circle, rectangle, polyline, text)
- `params` (object): Parameters for the vector
- `layer_name` (string, optional): Name of the layer to add the vector to

**Example:**
```python
circle = await session.execute_tool("create_vector", {
    "vector_type": "circle",
    "params": {
        "x": 50,
        "y": 50,
        "radius": 25
    },
    "layer_name": "MCP Example"
})
```

#### `create_toolpath`

Create a toolpath from vectors in the Vectric environment.

**Parameters:**
- `toolpath_type` (string): Type of toolpath (profile, pocket, drilling)
- `vector_ids` (array): List of vector IDs to use for toolpath
- `tool_name` (string): Name of the tool to use
- `params` (object, optional): Parameters for toolpath creation

**Example:**
```python
toolpath = await session.execute_tool("create_toolpath", {
    "toolpath_type": "profile",
    "vector_ids": ["vector-id-123"],
    "tool_name": "End Mill",
    "params": {
        "machine_vectors": "outside",
        "start_depth": 0,
        "cut_depth": 5
    }
})
```

### Available Resources

The server exposes the following resources:

- `vectric://job/info`: Basic information about the current job
- `vectric://job/layers`: Information about layers in the current job
- `vectric://job/toolpaths`: Information about toolpaths in the current job
- `vectric://job/vectors`: Information about vectors in the current job
- `vectric://job/models`: Information about 3D models in the current job (when available)

**Example:**
```python
resources = await session.list_resources("vectric://job")
job_info = await session.read_resource("vectric://job/info")
```

## Testing

To test the server without connecting to a real Lua Gadget, run:

```bash
python test_server.py
```

This will start the server with a mock Lua client and test all the available tools and resources.

## Client Example

An example client implementation is provided in `client_example.py`. This demonstrates how to use the server with the official MCP client SDK.

```bash
python client_example.py
```

## Differences from Custom Implementation

This implementation differs from the custom MCP server in the following ways:

1. Uses the official MCP Python SDK instead of a custom implementation
2. Provides a standardized interface that works with any MCP-compatible client
3. Offers improved resource handling and tool definitions
4. Follows the MCP protocol specification more closely

## Contributing

Contributions are welcome! Please follow the existing code style and add tests for any new features.

## License

This project is licensed under the same terms as the AiSpire project.