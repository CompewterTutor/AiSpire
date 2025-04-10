# AiSpire Lua Gadget Examples

This document provides a collection of example code snippets and complete workflows for common operations with the AiSpire Lua Gadget.

## Basic Vector Operations

### Creating Basic Shapes

```lua
-- Create a rectangle
local rect = RectangleHelper.create(10, 10, 110, 60, {
  layer = "My Layer",
  name = "My Rectangle"
})

-- Create a circle
local circle = CircleHelper.create(100, 100, 50, {
  layer = "My Layer",
  name = "My Circle"
})

-- Create a polygon
local polygon = PolygonHelper.createRegular(200, 200, 50, 6, 0, {
  layer = "My Layer",
  name = "My Hexagon"
})

-- Create a star
local star = PolygonHelper.createStar(300, 200, 50, 25, 5, 0, {
  layer = "My Layer",
  name = "My Star"
})
```

### Boolean Operations

```lua
-- Create two overlapping shapes
local rect = RectangleHelper.create(50, 50, 150, 150)
local circle = CircleHelper.create(125, 125, 50)

-- Union (combine shapes)
local union = PathBooleanHelper.union({rect, circle})

-- Subtraction (cut circle from rectangle)
local subtraction = PathBooleanHelper.subtract(rect, circle)

-- Intersection (keep only where shapes overlap)
local intersection = PathBooleanHelper.intersect(rect, circle)

-- Create a complex shape with multiple operations
local rect2 = RectangleHelper.create(100, 75, 175, 200)
local complex = PathBooleanHelper.union({
  PathBooleanHelper.subtract(rect, circle),
  rect2
})
```

### Path Modification

```lua
-- Create a base shape
local rect = RectangleHelper.create(50, 50, 150, 150)

-- Create an offset path (outside)
local outside_offset = PathModificationHelper.offset(rect, 10, {
  corner_type = "round",
  layer = "Offset Paths"
})

-- Create an offset path (inside)
local inside_offset = PathModificationHelper.offset(rect, -10, {
  corner_type = "round",
  layer = "Offset Paths"
})

-- Scale a path
local scaled_rect = PathModificationHelper.scale(rect, 1.5, 2.0, 100, 100)

-- Rotate a path
local rotated_rect = PathModificationHelper.rotate(rect, 45, 100, 100)
```

## Text and Dimensions

### Creating Text

```lua
-- Create simple text
local text = TextHelper.create("AiSpire Text", 100, 100, {
  font = "Arial",
  size = 18,
  bold = true,
  italic = false,
  layer = "Text Layer"
})

-- Text with specific alignment
local aligned_text = TextHelper.create("Right Aligned Text", 300, 100, {
  font = "Times New Roman",
  size = 14,
  alignment = "right",
  layer = "Text Layer"
})

-- Create text that follows a path
local arc = ArcHelper.create(200, 200, 100, 0, 180)
local text_on_path = TextHelper.createOnPath("Text Following Arc Path", arc, {
  font = "Verdana",
  size = 12,
  spacing = 1.1,
  layer = "Text Layer"
})
```

### Creating Dimensions

```lua
-- Create a linear dimension
local dim1 = DimensionHelper.createLinear(50, 50, 200, 50, 20, {
  text_size = 10,
  arrow_size = 5,
  precision = 1,  -- decimal places
  layer = "Dimensions"
})

-- Create an angular dimension
local dim2 = DimensionHelper.createAngular(150, 150, 75, 0, 45, {
  text_size = 10,
  arrow_size = 5,
  precision = 0,  -- decimal places
  layer = "Dimensions"
})

-- Create a diameter dimension
local circle = CircleHelper.create(300, 150, 40)
local dim3 = DimensionHelper.createDiameter(circle, 20, {
  text_size = 10,
  arrow_size = 5,
  precision = 1,
  layer = "Dimensions"
})
```

## 3D Model Operations

### Importing and Positioning Models

```lua
-- Import a 3D model file
local model = ModelImportHelper.import("/path/to/model.stl", {
  scale = 1.0,
  x_pos = 100,
  y_pos = 100,
  z_pos = 0
})

-- Position the model at the center of the material
ModelTransformHelper.position(model, "center", "on_surface")

-- Position model at specific coordinates
ModelTransformHelper.position(model, "custom", "at_height", 5.0, {
  x = 150,
  y = 150
})
```

### Creating Basic 3D Shapes

```lua
-- Create a 3D cube
local cube = ModelImportHelper.createBasicShape("cube", {
  width = 50,
  height = 50,
  depth = 20,
  position = {x = 100, y = 100, z = 0}
})

-- Create a cylinder
local cylinder = ModelImportHelper.createBasicShape("cylinder", {
  radius = 25,
  height = 30,
  position = {x = 200, y = 100, z = 0}
})

-- Create a sphere
local sphere = ModelImportHelper.createBasicShape("sphere", {
  radius = 20,
  position = {x = 300, y = 100, z = 20}
})
```

### Combining 3D Models

```lua
-- Create two basic shapes
local cube = ModelImportHelper.createBasicShape("cube", {
  width = 50, height = 50, depth = 20,
  position = {x = 125, y = 125, z = 0}
})

local cylinder = ModelImportHelper.createBasicShape("cylinder", {
  radius = 15, height = 40,
  position = {x = 125, y = 125, z = 10}
})

-- Combine models with addition (union)
local combined_add = ModelCombineHelper.combine({cube, cylinder}, "add")

-- Combine models with subtraction
local combined_subtract = ModelCombineHelper.combine({cube, cylinder}, "subtract")

-- Combine models with intersection
local combined_intersect = ModelCombineHelper.combine({cube, cylinder}, "intersect")
```

## Vector Nesting

### Basic Nesting Operation

```lua
-- Create an array of shapes to nest
local shapes = {}

-- Add some rectangles of different sizes
for i = 1, 5 do
  table.insert(shapes, RectangleHelper.create(0, 0, 
    math.random(30, 80), math.random(20, 60)))
end

-- Add some circles of different sizes
for i = 1, 5 do
  table.insert(shapes, CircleHelper.create(0, 0, math.random(15, 35)))
end

-- Perform nesting operation
local nestingResult = NestingHelper.nestVectors(shapes, {
  materialWidth = 400,
  materialHeight = 300,
  spacing = 5,
  algorithm = "bottomLeft"
})

-- Apply nesting results to Vectric objects
NestingHelper.applyNesting(nestingResult)

-- Show nesting report
local report = NestingHelper.createNestingReport(nestingResult)
Global.MessageBox(report)
```

### Advanced Nesting with Genetic Algorithm

```lua
-- Create shapes to nest (reusing the shapes array from previous example)

-- Perform nesting with genetic algorithm for optimal placement
local nestingResult = NestingHelper.nestVectors(shapes, {
  materialWidth = 400,
  materialHeight = 300,
  spacing = 5,
  algorithm = "genetic",
  rotationAllowed = true,
  rotationSteps = 8,  -- Allow rotation in 45° increments
  populationSize = 100,
  generations = 200,
  mutationRate = 0.2
})

-- Apply nesting results and generate report
NestingHelper.applyNesting(nestingResult)
local report = NestingHelper.createNestingReport(nestingResult)
```

## Toolpath Operations

### Creating Profile Toolpaths

```lua
-- Create a shape to cut
local circle = CircleHelper.create(100, 100, 50)

-- Create outside profile toolpath
local outside_profile = ProfileToolpathHelper.create(circle, {
  cut_depth = 10,
  tool_diameter = 6,
  outside = true,
  name = "Outside Circle Profile",
  allowance = 0.0,
  pass_depth = 5
})

-- Create inside profile toolpath
local rect = RectangleHelper.create(200, 50, 300, 150)
local inside_profile = ProfileToolpathHelper.create(rect, {
  cut_depth = 15,
  tool_diameter = 6,
  outside = false,  -- Inside profile
  name = "Inside Rectangle Profile",
  allowance = 0.5,  -- Leave 0.5mm material
  ramp = 5.0        -- 5mm ramp-in
})
```

### Creating Pocket Toolpaths

```lua
-- Create a shape to pocket
local rect = RectangleHelper.create(50, 50, 150, 150)

-- Create a pocket toolpath
local pocket = PocketToolpathHelper.create(rect, {
  cut_depth = 10,
  tool_diameter = 6,
  name = "Rectangle Pocket",
  stepover = 40,    -- 40% stepover
  pass_depth = 3,
  clearance = 5     -- 5mm safety height
})

-- Set specific pocket strategy
PocketToolpathHelper.setStrategy(pocket, "offset", {
  start_position = "center"
})

-- Create a pocket with islands
local outer = RectangleHelper.create(200, 50, 350, 150)
local island = CircleHelper.create(275, 100, 30)

-- Combine shapes to create pocket with island
local combined = PathBooleanHelper.subtract(outer, island)

-- Create pocket toolpath with island
local pocket_with_island = PocketToolpathHelper.create(combined, {
  cut_depth = 8,
  tool_diameter = 6,
  name = "Pocket with Island",
  stepover = 50
})
```

### Creating Drilling Toolpaths

```lua
-- Create an array of drilling points
local points = {
  {x = 50, y = 50},
  {x = 50, y = 150},
  {x = 150, y = 50},
  {x = 150, y = 150}
}

-- Create a drilling toolpath
local drilling = DrillingToolpathHelper.create(points, {
  cut_depth = 10,
  tool_diameter = 8,
  name = "Drilling Operation",
  dwell = 1.0,  -- 1 second dwell at bottom
  peck = 5.0    -- 5mm peck drilling
})
```

### Creating 3D Toolpaths

```lua
-- Import a 3D model
local model = ModelImportHelper.import("/path/to/model.stl", {
  scale = 1.0,
  position = {x = 100, y = 100, z = 0}
})

-- Create a roughing toolpath
local roughing = ThreeDToolpathHelper.createRoughing(model, {
  tool_diameter = 6,
  name = "3D Roughing",
  stepover = 50,    -- 50% stepover
  pass_depth = 2.0, -- 2mm depth per pass
  allowance = 1.0   -- Leave 1mm for finishing
})

-- Create a finishing toolpath
local finishing = ThreeDToolpathHelper.createFinishing(model, {
  tool_diameter = 3,
  name = "3D Finishing",
  stepover = 20,    -- 20% stepover
  strategy = "parallel",
  angle = 0,        -- Direction angle for parallel strategy
  allowance = 0.0   -- No additional allowance
})
```

## Complete Workflow Examples

### Sign Making Workflow

```lua
-- This example creates a simple text sign with border and toolpaths

-- Create material setup
local job = Job:GetMaterialBlock()
job:SetWidth(300)
job:SetHeight(150)
job:SetThickness(18)
job:Update()

-- Create layers
local layerManager = Job:GetLayerManager()
layerManager:AddNewLayer("Border", Color.new(255, 0, 0), true, true)
layerManager:AddNewLayer("Text", Color.new(0, 0, 255), true, true)

-- Create border with rounded corners
local border = RectangleHelper.createRounded(10, 10, 290, 140, 15, {
  layer = "Border"
})

-- Create text
local text = TextHelper.create("AiSpire", 150, 75, {
  font = "Arial",
  size = 36,
  bold = true,
  alignment = "center",
  vertical_alignment = "middle",
  layer = "Text"
})

-- Create toolpaths
-- Border pocket first
local border_pocket = PocketToolpathHelper.create(border, {
  cut_depth = 5,
  tool_diameter = 6,
  name = "Border Pocket",
  stepover = 40,
  pass_depth = 2.5
})

-- Text pocket
local text_pocket = PocketToolpathHelper.create(text, {
  cut_depth = 10,
  tool_diameter = 3,
  name = "Text Pocket",
  stepover = 30,
  pass_depth = 2
})

-- Calculate all toolpaths
local toolpathManager = Job:GetToolpathManager()
toolpathManager:RecalculateAllToolpaths()

-- Display preview
VectricJob.DisplayToolpathPreviewForm()
```

### Parts Nesting and Cutting Workflow

```lua
-- This example creates multiple parts, nests them efficiently,
-- and creates toolpaths for cutting them out

-- Create various shapes to cut
local shapes = {}

-- Create some puzzle pieces
table.insert(shapes, RectangleHelper.createRounded(0, 0, 100, 50, 10))

local circle1 = CircleHelper.create(0, 0, 40)
table.insert(shapes, circle1)

local hexagon = PolygonHelper.createRegular(0, 0, 35, 6, 0)
table.insert(shapes, hexagon)

local star = PolygonHelper.createStar(0, 0, 40, 20, 5, 0)
table.insert(shapes, star)

-- Create 3 copies of each shape
local all_shapes = {}
for i = 1, 3 do
  for _, shape in ipairs(shapes) do
    table.insert(all_shapes, shape:Clone())
  end
end

-- Nest the shapes efficiently
local nestingResult = NestingHelper.nestVectors(all_shapes, {
  materialWidth = 600,
  materialHeight = 400,
  spacing = 8,
  algorithm = "genetic",
  rotationAllowed = true
})

-- Apply nesting results
NestingHelper.applyNesting(nestingResult)

-- Create profile toolpaths for all shapes
local toolpathManager = Job:GetToolpathManager()
local allToolpaths = {}

for _, obj in ipairs(nestingResult.objects) do
  if not obj.overflow then
    local profile = ProfileToolpathHelper.create(obj.original, {
      cut_depth = 18, -- Cut all the way through
      tool_diameter = 6,
      outside = true,
      name = "Profile " .. obj.id,
      allowance = 0.0,
      tabs = {  -- Add tabs to hold pieces
        count = 2,
        thickness = 3,
        width = 8
      }
    })
    table.insert(allToolpaths, profile)
  end
end

-- Calculate all toolpaths
toolpathManager:RecalculateAllToolpaths()

-- Show material utilization report
local report = NestingHelper.createNestingReport(nestingResult)
Global.MessageBox(report)

-- Display preview
VectricJob.DisplayToolpathPreviewForm()
```

### 3D Project Workflow

```lua
-- This example creates a project with both 2D and 3D elements

-- Setup material
local job = Job:GetMaterialBlock()
job:SetWidth(400)
job:SetHeight(300)
job:SetThickness(40)
job:Update()

-- Create layers
local layerManager = Job:GetLayerManager()
layerManager:AddNewLayer("Border", Color.new(255, 0, 0), true, false)
layerManager:AddNewLayer("3D Model", Color.new(0, 0, 255), true, true)

-- Create an outer border for the piece
local border = RectangleHelper.create(10, 10, 390, 290, {
  layer = "Border"
})

-- Import a 3D model and position it
local model = ModelImportHelper.import("/path/to/model.stl", {
  scale = 0.8,
  layer = "3D Model"
})

-- Position the model at the center
ModelTransformHelper.position(model, "center", "on_surface")

-- Create a profile toolpath for the border
local border_profile = ProfileToolpathHelper.create(border, {
  cut_depth = 40,  -- Cut through
  tool_diameter = 6,
  outside = true,
  name = "Border Profile",
  tabs = {
    count = 4,
    thickness = 5,
    width = 10
  }
})

-- Create 3D roughing toolpath
local roughing = ThreeDToolpathHelper.createRoughing(model, {
  tool_diameter = 6,
  name = "3D Roughing",
  stepover = 50,
  pass_depth = 4.0,
  allowance = 1.0
})

-- Create 3D finishing toolpath
local finishing = ThreeDToolpathHelper.createFinishing(model, {
  tool_diameter = 3,
  name = "3D Finishing",
  stepover = 15,
  strategy = "raster",
  angle = 45
})

-- Create a pencil finishing pass for sharp details
local pencil = ThreeDToolpathHelper.createPencil(model, {
  tool_diameter = 1.5,
  name = "Pencil Detail",
  stepover = 10
})

-- Calculate all toolpaths
local toolpathManager = Job:GetToolpathManager()
toolpathManager:RecalculateAllToolpaths()

-- Save the job
Job:Save("/path/to/save/project.crv")

-- Display preview
VectricJob.DisplayToolpathPreviewForm()
```
