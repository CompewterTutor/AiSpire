"""
Mock Vectric SDK for testing

This module simulates the Vectric Aspire/V-Carve SDK for testing purposes.
It provides mock implementations of SDK functions used by the Lua Gadget.

Author: AiSpire Team
Version: 0.1.0 (Development)
"""

import time
import uuid


class MockVectricSDK:
    """Mock implementation of the Vectric SDK for testing."""
    
    def __init__(self):
        """Initialize the mock SDK with default state."""
        self.job = {
            "name": "Test Job",
            "width": 300,
            "height": 200,
            "material_thickness": 18
        }
        self.objects = {}
        self.layers = {
            "Layer 1": {"color": "#FF0000", "visible": True, "active": True},
            "Layer 2": {"color": "#00FF00", "visible": True, "active": False},
        }
        self.toolpaths = {}
        self.tools = {
            "1": {"name": "End Mill 6mm", "diameter": 6.0, "feedrate": 1000, "plungerate": 500},
            "2": {"name": "Ball Nose 3mm", "diameter": 3.0, "feedrate": 800, "plungerate": 400}
        }
    
    def get_current_state(self):
        """Get the current state of the mock environment."""
        return {
            "job": self.job,
            "object_count": len(self.objects),
            "layer_count": len(self.layers),
            "toolpath_count": len(self.toolpaths),
            "current_layer": "Layer 1"
        }
    
    # Job management functions
    
    def create_job(self, params):
        """Create a new job."""
        self.job = {
            "name": params.get("name", "New Job"),
            "width": params.get("width", 300),
            "height": params.get("height", 200),
            "material_thickness": params.get("thickness", 18)
        }
        self.objects = {}
        self.layers = {"Layer 1": {"color": "#FF0000", "visible": True, "active": True}}
        self.toolpaths = {}
        
        return {
            "job_name": self.job["name"],
            "success": True
        }
    
    def save_job(self, params):
        """Save the current job."""
        path = params.get("path", "/path/to/job.crv")
        return {
            "path": path,
            "success": True
        }
    
    def export_job(self, params):
        """Export the current job."""
        path = params.get("path", "/path/to/export.dxf")
        format = params.get("format", "dxf")
        
        return {
            "path": path,
            "format": format,
            "success": True
        }
    
    # Vector creation functions
    
    def create_circle(self, params):
        """Create a circle."""
        object_id = str(uuid.uuid4())
        self.objects[object_id] = {
            "type": "circle",
            "center_x": params.get("center_x", 0),
            "center_y": params.get("center_y", 0),
            "radius": params.get("radius", 10),
            "layer": params.get("layer", "Layer 1")
        }
        
        return {
            "object_id": object_id,
            "properties": self.objects[object_id]
        }
    
    def create_rectangle(self, params):
        """Create a rectangle."""
        object_id = str(uuid.uuid4())
        self.objects[object_id] = {
            "type": "rectangle",
            "x1": params.get("x1", 0),
            "y1": params.get("y1", 0),
            "x2": params.get("x2", 100),
            "y2": params.get("y2", 100),
            "corner_radius": params.get("corner_radius", 0),
            "layer": params.get("layer", "Layer 1")
        }
        
        return {
            "object_id": object_id,
            "properties": self.objects[object_id]
        }
    
    def create_polyline(self, params):
        """Create a polyline."""
        object_id = str(uuid.uuid4())
        self.objects[object_id] = {
            "type": "polyline",
            "points": params.get("points", []),
            "closed": params.get("closed", False),
            "layer": params.get("layer", "Layer 1")
        }
        
        return {
            "object_id": object_id,
            "properties": self.objects[object_id]
        }
    
    def create_text(self, params):
        """Create text."""
        object_id = str(uuid.uuid4())
        self.objects[object_id] = {
            "type": "text",
            "text": params.get("text", "Text"),
            "x": params.get("x", 0),
            "y": params.get("y", 0),
            "font": params.get("font", "Arial"),
            "size": params.get("size", 12),
            "layer": params.get("layer", "Layer 1")
        }
        
        return {
            "object_id": object_id,
            "properties": self.objects[object_id]
        }
    
    # Layer management functions
    
    def create_layer(self, params):
        """Create a new layer."""
        name = params.get("name", f"Layer {len(self.layers) + 1}")
        color = params.get("color", "#0000FF")
        visible = params.get("visible", True)
        
        if name in self.layers:
            return {
                "success": False,
                "message": "Layer already exists"
            }
            
        self.layers[name] = {
            "color": color,
            "visible": visible,
            "active": False
        }
        
        return {
            "layer_name": name,
            "success": True
        }
    
    def set_active_layer(self, params):
        """Set the active layer."""
        name = params.get("name", "Layer 1")
        
        if name not in self.layers:
            return {
                "success": False,
                "message": "Layer does not exist"
            }
        
        # Set all layers to inactive
        for layer in self.layers:
            self.layers[layer]["active"] = False
            
        # Set the specified layer to active
        self.layers[name]["active"] = True
        
        return {
            "layer_name": name,
            "success": True
        }
    
    # Toolpath functions
    
    def create_profile_toolpath(self, params):
        """Create a profile toolpath."""
        toolpath_id = str(uuid.uuid4())
        self.toolpaths[toolpath_id] = {
            "type": "profile",
            "name": params.get("name", f"Profile {len(self.toolpaths) + 1}"),
            "tool_id": params.get("tool_id", "1"),
            "cut_depth": params.get("cut_depth", 5),
            "objects": params.get("object_ids", []),
            "inside": params.get("inside", True),
            "calculated": False
        }
        
        return {
            "toolpath_id": toolpath_id,
            "properties": self.toolpaths[toolpath_id]
        }
    
    def create_pocket_toolpath(self, params):
        """Create a pocket toolpath."""
        toolpath_id = str(uuid.uuid4())
        self.toolpaths[toolpath_id] = {
            "type": "pocket",
            "name": params.get("name", f"Pocket {len(self.toolpaths) + 1}"),
            "tool_id": params.get("tool_id", "1"),
            "cut_depth": params.get("cut_depth", 5),
            "objects": params.get("object_ids", []),
            "stepover": params.get("stepover", 0.4),
            "calculated": False
        }
        
        return {
            "toolpath_id": toolpath_id,
            "properties": self.toolpaths[toolpath_id]
        }
    
    def calculate_toolpath(self, params):
        """Calculate a toolpath."""
        toolpath_id = params.get("toolpath_id", "")
        
        if toolpath_id not in self.toolpaths:
            return {
                "success": False,
                "message": "Toolpath does not exist"
            }
        
        # Simulate calculation time
        time.sleep(0.5)
        
        # Update toolpath status
        self.toolpaths[toolpath_id]["calculated"] = True
        
        return {
            "success": True,
            "toolpath_id": toolpath_id,
            "calculation_time": 0.5
        }
    
    # Utility functions
    
    def get_material_dimensions(self, params=None):
        """Get material dimensions."""
        return {
            "width": self.job["width"],
            "height": self.job["height"],
            "thickness": self.job["material_thickness"]
        }
    
    def get_object_by_id(self, params):
        """Get an object by ID."""
        object_id = params.get("object_id", "")
        
        if object_id not in self.objects:
            return {
                "success": False,
                "message": "Object does not exist"
            }
            
        return {
            "success": True,
            "object_id": object_id,
            "properties": self.objects[object_id]
        }
    
    def delete_object(self, params):
        """Delete an object."""
        object_id = params.get("object_id", "")
        
        if object_id not in self.objects:
            return {
                "success": False,
                "message": "Object does not exist"
            }
            
        del self.objects[object_id]
        
        return {
            "success": True,
            "object_id": object_id
        }
