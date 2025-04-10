# AiSpire Lua Gadget Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Configuration](#configuration)
4. [Core Components](#core-components)
   - [Socket Server](#socket-server)
   - [Command Parser](#command-parser)
   - [Execution Environment](#execution-environment)
5. [Helper Functions](#helper-functions)
   - [Path Creation and Manipulation](#path-creation-and-manipulation)
   - [Vector Drawing](#vector-drawing)
   - [3D Model Import and Manipulation](#3d-model-import-and-manipulation)
   - [Vector Nesting](#vector-nesting)
   - [Toolpath Creation](#toolpath-creation)
6. [Command Reference](#command-reference)
7. [Error Handling](#error-handling)
8. [Troubleshooting](#troubleshooting)
9. [Examples](#examples)

## Introduction

The AiSpire Lua Gadget is a plugin for Vectric Aspire/V-Carve that enables remote control of the CAD/CAM software via a socket connection. It serves as the bridge between the Python MCP Server and the Vectric software, allowing LLMs to manipulate the software using natural language.

### Key Features

- Socket server for remote communication
- Execution of arbitrary Lua code within Vectric
- Comprehensive helper functions for common CAD/CAM operations
- Error handling and logging system
- Secure execution environment with timeout mechanism
- Configuration management

## Installation

1. Locate your Vectric Aspire/V-Carve Gadgets folder:
   - Windows: `C:\ProgramData\Vectric\Aspire\Gadgets\` or `C:\ProgramData\Vectric\VCarve\Gadgets\`
   
2. Copy the `aispire_gadget.lua` file to the Gadgets folder

3. Start Vectric Aspire/V-Carve

4. Verify installation by checking the Gadgets menu for "AiSpire"

## Configuration

The AiSpire Lua Gadget can be configured using either the configuration dialog or by editing the config file directly.

### Configuration Options

| Option | Description | Default Value |
|--------|-------------|---------------|
| server_port | Socket server port | 9876 |
| allow_remote | Allow remote connections | false |
| authentication_token | Security token for authentication | random string |
| max_execution_time | Maximum time for code execution (ms) | 10000 |
| log_level | Logging verbosity (1-5) | 3 |
| auto_start | Start socket server on load | true |

### Configuration File

The configuration file is located at `%APPDATA%\Vectric\AiSpire\config.json` and uses JSON format:

```json
{
  "server_port": 9876,
  "allow_remote": false,
  "authentication_token": "your_secure_token_here",
  "max_execution_time": 10000,
  "log_level": 3,
  "auto_start": true
}
```

## Core Components

### Socket Server

The socket server component establishes a TCP server that listens for incoming connections from the Python MCP Server. It handles connection management, authentication, and message passing.

#### Key Functions:

```lua
-- Start the socket server
-- @param port The port number to listen on (default: value from config)
-- @return Success status and error message if applicable
function ServerManager.start(port)

-- Stop the socket server
-- @return Success status
function ServerManager.stop()

-- Check if server is currently running
-- @return Boolean indicating if the server is active
function ServerManager.isRunning()

-- Set authentication token
-- @param token The authentication token string
function ServerManager.setAuthToken(token)
```

### Command Parser

The command parser component processes incoming JSON messages, validates them against the expected schema, and prepares them for execution.

#### Command Format:

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

#### Key Functions:

```lua
-- Parse a command from JSON string
-- @param json_string The JSON command string
-- @return Parsed command table or nil and error message
function CommandParser.parse(json_string)

-- Validate a command against schema
-- @param command The command table to validate
-- @return Boolean indicating if command is valid and error message if not
function CommandParser.validate(command)
```

### Execution Environment

The execution environment provides a secure sandbox for running Lua code with access to the Vectric SDK while preventing harmful operations.

#### Key Functions:

```lua
-- Execute Lua code in sandbox environment
-- @param code The Lua code to execute
-- @param timeout Maximum execution time in milliseconds
-- @return Result of execution and error message if applicable
function Executor.executeCode(code, timeout)

-- Execute a predefined function with parameters
-- @param func_name The name of the function to execute
-- @param params Table of parameters for the function
-- @return Result of function execution and error message if applicable
function Executor.executeFunction(func_name, params)
```

## Helper Functions

### Path Creation and Manipulation

Helper functions for creating and manipulating vector paths.

#### CircleHelper

```lua
-- Create a circle with specified parameters
-- @param x Center X coordinate
-- @param y Center Y coordinate
-- @param radius Circle radius
-- @param options Table with additional options
-- @return Circle object or nil and error message
function CircleHelper.create(x, y, radius, options)

-- Create multiple circles in a pattern
-- @param pattern Pattern type ("grid", "radial", etc.)
-- @param params Pattern parameters
-- @return Array of circle objects or nil and error message
function CircleHelper.createPattern(pattern, params)
```

#### RectangleHelper

```lua
-- Create a rectangle with specified parameters
-- @param x1 Top-left X coordinate
-- @param y1 Top-left Y coordinate
-- @param x2 Bottom-right X coordinate
-- @param y2 Bottom-right Y coordinate
-- @param options Table with additional options (rounded corners, etc.)
-- @return Rectangle object or nil and error message
function RectangleHelper.create(x1, y1, x2, y2, options)

-- Create a rounded rectangle
-- @param x1 Top-left X coordinate
-- @param y1 Top-left Y coordinate
-- @param x2 Bottom-right X coordinate
-- @param y2 Bottom-right Y coordinate
-- @param corner_radius Radius for rounded corners
-- @return Rounded rectangle object or nil and error message
function RectangleHelper.createRounded(x1, y1, x2, y2, corner_radius)
```

#### PolygonHelper

```lua
-- Create a regular polygon
-- @param center_x Center X coordinate
-- @param center_y Center Y coordinate
-- @param radius Radius of circumscribed circle
-- @param sides Number of sides
-- @param rotation Rotation angle in degrees
-- @return Polygon object or nil and error message
function PolygonHelper.createRegular(center_x, center_y, radius, sides, rotation)

-- Create a star shape
-- @param center_x Center X coordinate
-- @param center_y Center Y coordinate
-- @param outer_radius Outer radius
-- @param inner_radius Inner radius
-- @param points Number of points
-- @param rotation Rotation angle in degrees
-- @return Star object or nil and error message
function PolygonHelper.createStar(center_x, center_y, outer_radius, inner_radius, points, rotation)
```

#### PathBooleanHelper

```lua
-- Perform union operation on paths
-- @param paths Array of path objects
-- @return Resulting path object or nil and error message
function PathBooleanHelper.union(paths)

-- Perform subtraction operation on paths
-- @param primary Primary path object
-- @param secondary Secondary path object to subtract
-- @return Resulting path object or nil and error message
function PathBooleanHelper.subtract(primary, secondary)

-- Perform intersection operation on paths
-- @param path1 First path object
-- @param path2 Second path object
-- @return Resulting path object or nil and error message
function PathBooleanHelper.intersect(path1, path2)
```

#### PathModificationHelper

```lua
-- Create an offset path
-- @param path Source path object
-- @param distance Offset distance (positive for outward, negative for inward)
-- @param options Table with additional options (corner type, etc.)
-- @return Offset path object or nil and error message
function PathModificationHelper.offset(path, distance, options)

-- Scale a path
-- @param path Source path object
-- @param scale_x X scale factor
-- @param scale_y Y scale factor (defaults to scale_x if not provided)
-- @param center_x X coordinate of scale center
-- @param center_y Y coordinate of scale center
-- @return Scaled path object or nil and error message
function PathModificationHelper.scale(path, scale_x, scale_y, center_x, center_y)
```

### Vector Drawing

Helper functions for creating vector drawings.

#### LineHelper

```lua
-- Create a line with specified parameters
-- @param x1 Start X coordinate
-- @param y1 Start Y coordinate
-- @param x2 End X coordinate
-- @param y2 End Y coordinate
-- @return Line object or nil and error message
function LineHelper.create(x1, y1, x2, y2)

-- Create multiple lines in a pattern
-- @param pattern Pattern type ("grid", "parallel", etc.)
-- @param params Pattern parameters
-- @return Array of line objects or nil and error message
function LineHelper.createPattern(pattern, params)
```

#### ArcHelper

```lua
-- Create an arc with specified parameters
-- @param center_x Arc center X coordinate
-- @param center_y Arc center Y coordinate
-- @param radius Arc radius
-- @param start_angle Start angle in degrees
-- @param end_angle End angle in degrees
-- @param options Table with additional options (direction, etc.)
-- @return Arc object or nil and error message
function ArcHelper.create(center_x, center_y, radius, start_angle, end_angle, options)
```

#### CurveHelper

```lua
-- Create a Bezier curve with specified parameters
-- @param x1 Start point X coordinate
-- @param y1 Start point Y coordinate
-- @param c1x First control point X coordinate
-- @param c1y First control point Y coordinate
-- @param c2x Second control point X coordinate
-- @param c2y Second control point Y coordinate
-- @param x2 End point X coordinate
-- @param y2 End point Y coordinate
-- @return Bezier curve object or nil and error message
function CurveHelper.createBezier(x1, y1, c1x, c1y, c2x, c2y, x2, y2)

-- Create a spline curve through points
-- @param points Array of point tables {x=x, y=y}
-- @param closed Boolean indicating if curve should be closed
-- @return Spline curve object or nil and error message
function CurveHelper.createSpline(points, closed)
```

#### TextHelper

```lua
-- Create text with specified parameters
-- @param text The text string to create
-- @param x X position of text
-- @param y Y position of text
-- @param options Table with additional options (font, size, etc.)
-- @return Text object or nil and error message
function TextHelper.create(text, x, y, options)

-- Create text along a path
-- @param text The text string to create
-- @param path The path to follow
-- @param options Table with additional options (alignment, spacing, etc.)
-- @return Text object or nil and error message
function TextHelper.createOnPath(text, path, options)
```

#### DimensionHelper

```lua
-- Create a linear dimension
-- @param x1 First point X coordinate
-- @param y1 First point Y coordinate
-- @param x2 Second point X coordinate
-- @param y2 Second point Y coordinate
-- @param offset Offset distance for dimension line
-- @param options Table with additional options (text, arrows, etc.)
-- @return Dimension object or nil and error message
function DimensionHelper.createLinear(x1, y1, x2, y2, offset, options)

-- Create an angular dimension
-- @param center_x Center X coordinate
-- @param center_y Center Y coordinate
-- @param radius Arc radius
-- @param start_angle Start angle in degrees
-- @param end_angle End angle in degrees
-- @param options Table with additional options
-- @return Angular dimension object or nil and error message
function DimensionHelper.createAngular(center_x, center_y, radius, start_angle, end_angle, options)
```

### 3D Model Import and Manipulation

Helper functions for importing and manipulating 3D models.

#### ModelImportHelper

```lua
-- Import a 3D model from file
-- @param filepath The path to the 3D model file
-- @param options Table with import options like scale, position, etc.
-- @return The imported model object or nil and error message if failed
function ModelImportHelper.import(filepath, options)

-- Create a basic 3D shape programmatically
-- @param shape_type String indicating the type of shape (cube, cylinder, sphere, etc.)
-- @param parameters Table with shape-specific parameters
-- @return The created shape model or nil and error message if failed
function ModelImportHelper.createBasicShape(shape_type, parameters)
```

#### ModelTransformHelper

```lua
-- Transform a 3D model
-- @param model The model object to transform
-- @param transformation Table with transformation parameters
-- @return Success status and error message if failed
function ModelTransformHelper.transform(model, transformation)

-- Position a 3D model on the material
-- @param model The model object to position
-- @param alignment String indicating alignment (center, top_left, etc.)
-- @param z_strategy String indicating Z positioning (on_surface, at_height, etc.)
-- @param z_value Number for specific Z height if needed
-- @return Success status and error message if failed
function ModelTransformHelper.position(model, alignment, z_strategy, z_value)
```

#### ModelCombineHelper

```lua
-- Combine multiple 3D models into a single composite model
-- @param models Array of model objects to combine
-- @param operation String indicating boolean operation (add, subtract, intersect)
-- @return The resulting composite model or nil and error message if failed
function ModelCombineHelper.combine(models, operation)
```

#### ModelExportHelper

```lua
-- Export a 3D model to file
-- @param model The model object to export
-- @param filepath The destination file path
-- @param format The export format (stl, obj, etc.)
-- @return Success status and error message if failed
function ModelExportHelper.export(model, filepath, format)
```

### Vector Nesting

Helper functions for efficiently nesting vector objects on material.

#### NestingHelper

```lua
-- Nest vector objects efficiently on material
-- @param objects Array of vector objects to nest
-- @param options Table with nesting options
-- @return Array of positioned objects and nesting statistics
function NestingHelper.nestVectors(objects, options)

-- Apply nesting results to actual Vectric objects
-- @param nestingResult Result from nestVectors function
-- @return true if successful, false otherwise
function NestingHelper.applyNesting(nestingResult)

-- Create a report of nesting results
-- @param nestingResult Result from nestVectors function
-- @return A string containing the nesting report
function NestingHelper.createNestingReport(nestingResult)
```

### Toolpath Creation

Helper functions for creating and configuring toolpaths.

#### ProfileToolpathHelper

```lua
-- Create a profile toolpath for specified objects
-- @param objects Array of objects to create toolpath for
-- @param options Table with toolpath options (depth, tool, etc.)
-- @return Toolpath object or nil and error message
function ProfileToolpathHelper.create(objects, options)

-- Set allowance for a profile toolpath
-- @param toolpath The toolpath to modify
-- @param allowance The material allowance value
-- @return Success status and error message if failed
function ProfileToolpathHelper.setAllowance(toolpath, allowance)
```

#### PocketToolpathHelper

```lua
-- Create a pocket toolpath for specified objects
-- @param objects Array of objects to create toolpath for
-- @param options Table with toolpath options (depth, tool, etc.)
-- @return Toolpath object or nil and error message
function PocketToolpathHelper.create(objects, options)

-- Set pocket clearing strategy
-- @param toolpath The toolpath to modify
-- @param strategy The clearing strategy to use
-- @param options Additional strategy options
-- @return Success status and error message if failed
function PocketToolpathHelper.setStrategy(toolpath, strategy, options)
```

#### DrillingToolpathHelper

```lua
-- Create a drilling toolpath for specified points
-- @param points Array of point coordinates for drilling
-- @param options Table with toolpath options (depth, tool, etc.)
-- @return Toolpath object or nil and error message
function DrillingToolpathHelper.create(points, options)
```

#### ThreeDToolpathHelper

```lua
-- Create a 3D roughing toolpath for specified model
-- @param model The 3D model to create toolpath for
-- @param options Table with toolpath options (tool, stepover, etc.)
-- @return Toolpath object or nil and error message
function ThreeDToolpathHelper.createRoughing(model, options)

-- Create a 3D finishing toolpath for specified model
-- @param model The 3D model to create toolpath for
-- @param options Table with toolpath options (tool, strategy, etc.)
-- @return Toolpath object or nil and error message
function ThreeDToolpathHelper.createFinishing(model, options)
```

## Command Reference

The AiSpire Lua Gadget supports three main command types:

### 1. Execute Code

Executes arbitrary Lua code within the Vectric environment.

```json
{
  "command_type": "execute_code",
  "payload": {
    "code": "local circle = Circle.new(); circle:SetCentre(100, 100); circle:SetRadius(50); return 'Circle created';"
  },
  "id": "cmd-001",
  "auth": "your_auth_token"
}
```

### 2. Execute Function

Executes a predefined helper function with parameters.

```json
{
  "command_type": "execute_function",
  "payload": {
    "function": "CircleHelper.create",
    "parameters": {
      "x": 100,
      "y": 100,
      "radius": 50,
      "options": {
        "layer": "Shapes"
      }
    }
  },
  "id": "cmd-002",
  "auth": "your_auth_token"
}
```

### 3. Query State

Queries the current state of the Vectric environment.

```json
{
  "command_type": "query_state",
  "payload": {
    "query": "material_block"
  },
  "id": "cmd-003",
  "auth": "your_auth_token"
}
```

## Error Handling

The AiSpire Lua Gadget implements a comprehensive error handling system that:

1. Catches and reports execution errors with line numbers and context
2. Provides detailed error messages for debugging
3. Recovers gracefully from errors without crashing
4. Logs errors with configurable verbosity

### Error Response Format

```json
{
  "status": "error",
  "result": {
    "message": "Human-readable error message",
    "type": "execution_error | timeout_error | validation_error | authentication_error",
    "details": {
      "line": 5,
      "code": "problematic code snippet",
      "suggestions": "potential fixes"
    }
  },
  "command_id": "original command identifier",
  "execution_time": 150
}
```

## Troubleshooting

### Common Issues and Solutions

#### Socket Connection Failures

**Symptom:** Unable to establish socket connection between MCP Server and Lua Gadget.

**Possible causes and solutions:**
- **Port already in use:** Change the port in configuration
- **Firewall blocking connection:** Add exception for the port
- **Wrong IP address:** Ensure connections are to 127.0.0.1 (localhost)

#### Execution Timeouts

**Symptom:** Long-running operations fail with timeout errors.

**Possible causes and solutions:**
- **Insufficient timeout value:** Increase `max_execution_time` in configuration
- **Inefficient code:** Optimize complex operations
- **Large data processing:** Break operations into smaller chunks

#### Authentication Failures

**Symptom:** Commands rejected with authentication errors.

**Possible causes and solutions:**
- **Incorrect token:** Ensure tokens match between MCP Server and Lua Gadget
- **Token not set:** Check if token is properly configured
- **Token expired:** Reset token if using time-based tokens

## Examples

### Basic Vector Creation

```lua
-- Create a simple rectangle
local rectangle = RectangleHelper.create(10, 10, 100, 50, {
  layer = "Shapes",
  name = "Rectangle 1"
})

-- Create a circle inside the rectangle
local circle = CircleHelper.create(55, 30, 20, {
  layer = "Shapes",
  name = "Circle 1"
})

-- Combine them with boolean subtraction
local result = PathBooleanHelper.subtract(rectangle, circle)
```

### Text on Path

```lua
-- Create an arc path
local arc = ArcHelper.create(100, 100, 50, 0, 180, {
  layer = "Text Path"
})

-- Create text that follows the arc
local text = TextHelper.createOnPath("AiSpire Text Example", arc, {
  font = "Arial",
  size = 12,
  alignment = "center",
  spacing = 1.0
})
```

### 3D Model Manipulation

```lua
-- Import a 3D model
local model = ModelImportHelper.import("/path/to/model.stl", {
  scale = 0.5,
  x_pos = 100,
  y_pos = 100,
  z_pos = 0
})

-- Position the model at the center of the material
ModelTransformHelper.position(model, "center", "on_surface")

-- Create a 3D toolpath for the model
local roughing = ThreeDToolpathHelper.createRoughing(model, {
  tool_diameter = 6.0,
  stepover = 40,
  pass_depth = 2.0
})

local finishing = ThreeDToolpathHelper.createFinishing(model, {
  tool_diameter = 3.0,
  stepover = 20,
  strategy = "parallel"
})
```

### Vector Nesting Example

```lua
-- Create some shapes to nest
local shapes = {}
for i = 1, 10 do
  table.insert(shapes, CircleHelper.create(0, 0, math.random(10, 30)))
end
for i = 1, 10 do
  table.insert(shapes, RectangleHelper.create(0, 0, 
    math.random(20, 50), math.random(20, 50)))
end

-- Nest the shapes efficiently
local nestingResult = NestingHelper.nestVectors(shapes, {
  materialWidth = 400,
  materialHeight = 300,
  spacing = 5,
  algorithm = "genetic",
  rotationAllowed = true
})

-- Apply the nesting results to the actual objects
NestingHelper.applyNesting(nestingResult)

-- Generate a report
local report = NestingHelper.createNestingReport(nestingResult)
Global.MessageBox(report)
```

### Complete Workflow Example

```lua
-- This example shows a complete workflow from vector creation to toolpath generation

-- Create material setup
local job = Job:GetMaterialBlock()
job:SetWidth(400)
job:SetHeight(300)
job:SetThickness(25)
job:Update()

-- Create a new layer
local layerManager = Job:GetLayerManager()
layerManager:AddNewLayer("Project Vectors", Color.new(255, 0, 0), true, true)

-- Create some vector shapes
local rect = RectangleHelper.create(50, 50, 350, 250, {
  layer = "Project Vectors"
})

local circle1 = CircleHelper.create(125, 125, 50, {
  layer = "Project Vectors"
})

local circle2 = CircleHelper.create(275, 125, 50, {
  layer = "Project Vectors"
})

local circle3 = CircleHelper.create(200, 200, 30, {
  layer = "Project Vectors"
})

-- Create pocket toolpath for the rectangle with the circles subtracted
local combinedShape = PathBooleanHelper.subtract(rect, 
  PathBooleanHelper.union({circle1, circle2, circle3}))

local pocketToolpath = PocketToolpathHelper.create(combinedShape, {
  cut_depth = 10,
  tool_diameter = 6,
  stepover = 40,
  name = "Main Pocket"
})

-- Create profile toolpaths for the circles
local profileToolpath1 = ProfileToolpathHelper.create(circle1, {
  cut_depth = 25,  -- Cut all the way through
  tool_diameter = 6,
  name = "Circle Profile 1",
  outside = true
})

local profileToolpath2 = ProfileToolpathHelper.create(circle2, {
  cut_depth = 25,
  tool_diameter = 6,
  name = "Circle Profile 2",
  outside = true
})

-- Calculate all toolpaths
local toolpathManager = Job:GetToolpathManager()
toolpathManager:RecalculateAllToolpaths()

-- Preview results
VectricJob.DisplayToolpathPreviewForm()
```
