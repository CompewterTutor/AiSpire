# AiSpire Helper Functions

This directory contains helper modules that provide simplified interfaces for common operations using the Vectric SDK.

## Modules

### Path Helpers (`path_helpers.lua`)

Functions for creating and manipulating paths and geometric shapes:

- `createCircle(centerX, centerY, radius)` - Creates a circle contour
- `createRectangle(x1, y1, x2, y2)` - Creates a rectangle contour
- `createPolygon(centerX, centerY, radius, sides, startAngle)` - Creates a regular polygon
- `offsetPath(contour, offset)` - Offsets a contour by the specified amount
- `scalePath(contour, scaleX, scaleY, centerX, centerY)` - Scales a contour
- `combineContours(contour1, contour2, operation)` - Combines contours using boolean operations

### Vector Drawing Helpers (`vector_helpers.lua`)

Functions for drawing vectors, text, and adding dimensions:

- `createLine(x1, y1, x2, y2)` - Creates a straight line between two points
- `createArc(x1, y1, x2, y2, bulge)` - Creates an arc between two points with specified bulge
- `createArcByCenterRadius(centerX, centerY, radius, startAngle, endAngle, clockwise)` - Creates an arc defined by center, radius and angles
- `createBezierCurve(x1, y1, x2, y2, ctrl1x, ctrl1y, ctrl2x, ctrl2y)` - Creates a Bezier curve
- `createPolyline(points, closed)` - Creates a polyline from a series of points
- `createText(x, y, text, options)` - Creates text with styling options
- `createLinearDimension(x1, y1, x2, y2, offset, options)` - Creates a linear dimension
- `createAngularDimension(x1, y1, x2, y2, x3, y3, radius, options)` - Creates an angular dimension
- `createGuide(position, isHorizontal, locked)` - Creates a horizontal or vertical guide line

### Usage Example

```lua
local PathHelpers = require("helpers.path_helpers")
local VectorHelpers = require("helpers.vector_helpers")

-- Create a circle with radius 10 at position (50, 50)
local circle = PathHelpers.createCircle(50, 50, 10)

-- Create a rectangle from (10, 10) to (40, 30)
local rectangle = PathHelpers.createRectangle(10, 10, 40, 30)

-- Create a straight line from (0,0) to (100,100)
local line = VectorHelpers.createLine(0, 0, 100, 100)

-- Create text
local text = VectorHelpers.createText(50, 50, "Hello Vectric", {
    font = "Arial", 
    size = 12, 
    bold = true,
    alignment = "center"
})

-- Create a bezier curve
local curve = VectorHelpers.createBezierCurve(10, 10, 100, 100, 25, 75, 75, 25)

-- Create a dimension
local dimension = VectorHelpers.createLinearDimension(10, 10, 100, 10, 20, {
    units = "mm",
    precision = 2
})
```

More helper modules will be added as development progresses.
