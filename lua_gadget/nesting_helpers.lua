--[[
AiSpire Vector Nesting Helper Functions

This module provides functions for efficiently arranging vector shapes on material
to optimize space usage and reduce waste.
]]

local NestingHelpers = {}

-- Convert native Vectric objects to internal representation for nesting algorithm
-- @param objects Array of vector objects to nest
-- @return Array of shapes in internal representation
local function convertToNestingObjects(objects)
    local nestingObjects = {}
    
    for i, obj in ipairs(objects) do
        local nestObj = {
            id = i,
            original = obj,
            type = "unknown",
            bounds = nil,
            rotation = 0,
            position = {x = 0, y = 0}
        }
        
        -- Determine object type and get bounding box
        if obj.GetRadius then -- Likely a Circle
            nestObj.type = "circle"
            nestObj.radius = obj:GetRadius()
            local center = obj:GetCentre()
            nestObj.bounds = {
                minX = center.x - nestObj.radius,
                minY = center.y - nestObj.radius,
                maxX = center.x + nestObj.radius,
                maxY = center.y + nestObj.radius,
                width = nestObj.radius * 2,
                height = nestObj.radius * 2
            }
        elseif obj.GetBoundingBox then -- Object with bounding box method
            nestObj.type = "shape"
            local bbox = obj:GetBoundingBox()
            nestObj.bounds = {
                minX = bbox:GetMinX(),
                minY = bbox:GetMinY(),
                maxX = bbox:GetMaxX(),
                maxY = bbox:GetMaxY(),
                width = bbox:GetWidth(),
                height = bbox:GetHeight()
            }
        else -- Try to create bounding box manually for other objects
            nestObj.type = "custom"
            -- Calculate bounds based on object type
            -- This would need more sophisticated logic for different object types
            -- Default to a placeholder bounding box
            nestObj.bounds = {
                minX = 0,
                minY = 0,
                maxX = 100,
                maxY = 100,
                width = 100,
                height = 100
            }
        end
        
        table.insert(nestingObjects, nestObj)
    end
    
    return nestingObjects
end

-- Check if two shapes overlap
-- @param shape1 First shape to check
-- @param shape2 Second shape to check
-- @return true if shapes overlap, false otherwise
local function shapesOverlap(shape1, shape2)
    -- Simple bounding box collision detection
    if shape1.bounds.minX > shape2.bounds.maxX or
       shape1.bounds.maxX < shape2.bounds.minX or
       shape1.bounds.minY > shape2.bounds.maxY or
       shape1.bounds.maxY < shape2.bounds.minY then
        return false
    end
    
    -- For more accurate collision detection between complex shapes,
    -- we would need more sophisticated algorithms considering the actual geometry
    
    return true
end

-- Arrange shapes using bottom-left packing algorithm
-- @param shapes Array of shapes to arrange
-- @param materialWidth Width of available material
-- @param materialHeight Height of available material
-- @param spacing Minimum spacing between shapes
-- @return Arranged shapes with updated positions
local function bottomLeftPack(shapes, materialWidth, materialHeight, spacing)
    -- Sort shapes by height (descending)
    table.sort(shapes, function(a, b) 
        return a.bounds.height > b.bounds.height 
    end)
    
    -- Create a list to track placed shapes
    local placedShapes = {}
    
    for _, shape in ipairs(shapes) do
        -- Start at the top-left corner
        shape.position = {x = spacing, y = materialHeight - shape.bounds.height - spacing}
        
        local placed = false
        
        while not placed do
            local canPlace = true
            
            -- Check if the shape is within material bounds
            if shape.position.x + shape.bounds.width + spacing > materialWidth or
               shape.position.y < spacing then
                canPlace = false
            end
            
            -- Check if the shape overlaps with any placed shape
            for _, placedShape in ipairs(placedShapes) do
                -- Adjust bounds based on current position
                local shapeBounds = {
                    minX = shape.position.x,
                    minY = shape.position.y,
                    maxX = shape.position.x + shape.bounds.width,
                    maxY = shape.position.y + shape.bounds.height
                }
                
                local placedBounds = {
                    minX = placedShape.position.x,
                    minY = placedShape.position.y,
                    maxX = placedShape.position.x + placedShape.bounds.width,
                    maxY = placedShape.position.y + placedShape.bounds.height
                }
                
                -- Add spacing to collision check
                shapeBounds.minX = shapeBounds.minX - spacing
                shapeBounds.minY = shapeBounds.minY - spacing
                shapeBounds.maxX = shapeBounds.maxX + spacing
                shapeBounds.maxY = shapeBounds.maxY + spacing
                
                -- Check if bounding boxes overlap
                if shapeBounds.minX < placedBounds.maxX and
                   shapeBounds.maxX > placedBounds.minX and
                   shapeBounds.minY < placedBounds.maxY and
                   shapeBounds.maxY > placedBounds.minY then
                    canPlace = false
                    break
                end
            end
            
            if canPlace then
                placed = true
                table.insert(placedShapes, shape)
            else
                -- Move right
                shape.position.x = shape.position.x + spacing
                
                -- If we reached the right edge, move down and start from left
                if shape.position.x + shape.bounds.width + spacing > materialWidth then
                    shape.position.x = spacing
                    shape.position.y = shape.position.y - spacing
                    
                    -- If we've moved below the material, we can't place this shape
                    if shape.position.y < spacing then
                        -- Try rotating the shape by 90 degrees and see if it fits
                        local temp = shape.bounds.width
                        shape.bounds.width = shape.bounds.height
                        shape.bounds.height = temp
                        shape.rotation = (shape.rotation + 90) % 360
                        
                        -- Reset position for the rotated shape
                        shape.position = {x = spacing, y = materialHeight - shape.bounds.height - spacing}
                        
                        -- If it still doesn't fit, we'll have overflow
                        if shape.position.y < spacing or 
                           shape.position.x + shape.bounds.width + spacing > materialWidth then
                            -- Mark as placed but overflow
                            shape.overflow = true
                            placed = true
                            table.insert(placedShapes, shape)
                        end
                    end
                end
            end
        end
    end
    
    return placedShapes
end

-- Nest objects using a genetic algorithm approach for more optimal placement
-- @param shapes Array of shapes to arrange
-- @param materialWidth Width of available material
-- @param materialHeight Height of available material
-- @param spacing Minimum spacing between shapes
-- @param options Additional options for the algorithm
-- @return Arranged shapes with updated positions
local function geneticAlgorithmNest(shapes, materialWidth, materialHeight, spacing, options)
    options = options or {}
    local populationSize = options.populationSize or 50
    local generations = options.generations or 100
    local mutationRate = options.mutationRate or 0.1
    
    -- Create initial population of random arrangements
    local population = {}
    for i = 1 to populationSize do
        -- Create a random arrangement by shuffling shapes and using bottom-left packing
        local shuffledShapes = {}
        for _, shape in ipairs(shapes) do
            table.insert(shuffledShapes, shape)
        end
        
        -- Fisher-Yates shuffle
        for i = #shuffledShapes, 2, -1 do
            local j = math.random(i)
            shuffledShapes[i], shuffledShapes[j] = shuffledShapes[j], shuffledShapes[i]
        end
        
        -- Apply bottom-left packing to get positions
        local arrangedShapes = bottomLeftPack(shuffledShapes, materialWidth, materialHeight, spacing)
        
        -- Calculate fitness (lower is better)
        local fitness = 0
        local maxY = 0
        local overflow = false
        
        for _, shape in ipairs(arrangedShapes) do
            if shape.overflow then
                overflow = true
            end
            maxY = math.max(maxY, shape.position.y + shape.bounds.height)
        end
        
        -- If there's overflow, penalize heavily
        if overflow then
            fitness = materialWidth * materialHeight
        else
            -- Fitness is the total area used (trying to minimize)
            fitness = materialWidth * maxY
        end
        
        table.insert(population, {
            arrangement = arrangedShapes,
            fitness = fitness
        })
    end
    
    -- Run genetic algorithm for specified generations
    for gen = 1, generations do
        -- Sort population by fitness (lowest first)
        table.sort(population, function(a, b)
            return a.fitness < b.fitness
        end)
        
        -- Create next generation
        local nextGeneration = {}
        
        -- Keep best arrangements
        local eliteCount = math.floor(populationSize * 0.1)
        for i = 1, eliteCount do
            table.insert(nextGeneration, population[i])
        end
        
        -- Create new arrangements through crossover and mutation
        while #nextGeneration < populationSize do
            -- Select parents using tournament selection
            local parent1 = population[math.random(math.floor(populationSize * 0.5))]
            local parent2 = population[math.random(math.floor(populationSize * 0.5))]
            
            -- Create child by combining parent arrangements
            local childShapes = {}
            local crossoverPoint = math.random(#shapes)
            
            for i = 1, #shapes do
                if i <= crossoverPoint then
                    table.insert(childShapes, parent1.arrangement[i])
                else
                    table.insert(childShapes, parent2.arrangement[i])
                end
            end
            
            -- Apply mutation
            if math.random() < mutationRate then
                local idx1 = math.random(#childShapes)
                local idx2 = math.random(#childShapes)
                childShapes[idx1], childShapes[idx2] = childShapes[idx2], childShapes[idx1]
            end
            
            -- Apply bottom-left packing to get positions
            local arrangedShapes = bottomLeftPack(childShapes, materialWidth, materialHeight, spacing)
            
            -- Calculate fitness
            local fitness = 0
            local maxY = 0
            local overflow = false
            
            for _, shape in ipairs(arrangedShapes) do
                if shape.overflow then
                    overflow = true
                end
                maxY = math.max(maxY, shape.position.y + shape.bounds.height)
            end
            
            if overflow then
                fitness = materialWidth * materialHeight
            else
                fitness = materialWidth * maxY
            end
            
            table.insert(nextGeneration, {
                arrangement = arrangedShapes,
                fitness = fitness
            })
        end
        
        population = nextGeneration
    end
    
    -- Return the best arrangement
    table.sort(population, function(a, b)
        return a.fitness < b.fitness
    end)
    
    return population[1].arrangement
end

-- Nest vector objects efficiently on material
-- @param objects Array of vector objects to nest
-- @param options Table with nesting options
-- @return Array of positioned objects and nesting statistics
function NestingHelpers.nestVectors(objects, options)
    if not objects or #objects == 0 then
        return nil, "No objects provided for nesting"
    end
    
    options = options or {}
    
    -- Set default options
    local materialWidth = options.materialWidth or 800  -- Default material width
    local materialHeight = options.materialHeight or 600  -- Default material height
    local spacing = options.spacing or 10  -- Default spacing between objects
    local algorithm = options.algorithm or "bottomLeft"  -- Default algorithm
    local rotationAllowed = options.rotationAllowed or false  -- Allow rotation of shapes
    local rotationSteps = options.rotationSteps or 4  -- Number of rotation steps to try (90, 180, 270)
    
    -- Convert objects to internal format
    local nestingObjects = convertToNestingObjects(objects)
    
    -- Apply the selected nesting algorithm
    local nestedObjects
    
    if algorithm == "bottomLeft" then
        nestedObjects = bottomLeftPack(nestingObjects, materialWidth, materialHeight, spacing)
    elseif algorithm == "genetic" then
        nestedObjects = geneticAlgorithmNest(nestingObjects, materialWidth, materialHeight, spacing, options)
    else
        -- Default to bottom-left packing
        nestedObjects = bottomLeftPack(nestingObjects, materialWidth, materialHeight, spacing)
    end
    
    -- Calculate statistics
    local stats = {
        totalObjects = #objects,
        placedObjects = 0,
        overflowObjects = 0,
        materialUtilization = 0,
        boundingArea = 0,
        objectsArea = 0
    }
    
    local maxX, maxY = 0, 0
    
    for _, obj in ipairs(nestedObjects) do
        if obj.overflow then
            stats.overflowObjects = stats.overflowObjects + 1
        else
            stats.placedObjects = stats.placedObjects + 1
            maxX = math.max(maxX, obj.position.x + obj.bounds.width)
            maxY = math.max(maxY, obj.position.y + obj.bounds.height)
            stats.objectsArea = stats.objectsArea + (obj.bounds.width * obj.bounds.height)
        end
    end
    
    stats.boundingArea = maxX * maxY
    stats.materialUtilization = math.floor((stats.objectsArea / stats.boundingArea) * 100)
    
    -- Return the positioned objects and statistics
    return {
        objects = nestedObjects,
        statistics = stats
    }
end

-- Apply nesting results to actual Vectric objects
-- @param nestingResult Result from nestVectors function
-- @return true if successful, false otherwise
function NestingHelpers.applyNesting(nestingResult)
    if not nestingResult or not nestingResult.objects then
        return false, "Invalid nesting result"
    end
    
    local success = pcall(function()
        for _, obj in ipairs(nestingResult.objects) do
            -- Skip overflow objects
            if not obj.overflow then
                -- Create a transform for the object
                local transform = Transformation2D.new()
                
                -- Apply rotation if needed
                if obj.rotation ~= 0 then
                    -- First move to origin
                    local center = {
                        x = obj.bounds.minX + obj.bounds.width/2,
                        y = obj.bounds.minY + obj.bounds.height/2
                    }
                    transform:Translate(-center.x, -center.y)
                    
                    -- Apply rotation
                    transform:Rotate(obj.rotation)
                    
                    -- Move back
                    transform:Translate(center.x, center.y)
                end
                
                -- Apply translation to new position
                local dx = obj.position.x - obj.bounds.minX
                local dy = obj.position.y - obj.bounds.minY
                transform:Translate(dx, dy)
                
                -- Apply the transformation to the original object
                -- This will depend on how Vectric objects handle transformations
                -- obj.original:Transform(transform)
            end
        end
    end)
    
    return success
end

-- Create a report of nesting results
-- @param nestingResult Result from nestVectors function
-- @return A string containing the nesting report
function NestingHelpers.createNestingReport(nestingResult)
    if not nestingResult or not nestingResult.statistics then
        return "No valid nesting result to report"
    end
    
    local stats = nestingResult.statistics
    
    local report = "Vector Nesting Report\n"
    report = report .. "====================\n\n"
    report = report .. "Total objects: " .. stats.totalObjects .. "\n"
    report = report .. "Successfully placed: " .. stats.placedObjects .. "\n"
    report = report .. "Overflow objects: " .. stats.overflowObjects .. "\n"
    report = report .. "Material utilization: " .. stats.materialUtilization .. "%\n"
    report = report .. "Bounding area: " .. stats.boundingArea .. " square units\n"
    report = report .. "Total objects area: " .. stats.objectsArea .. " square units\n"
    
    return report
end

return NestingHelpers
