"""
Template engine for generating Lua code from templates.
"""
import string
from typing import Dict, Any, List, Optional


class LuaTemplate:
    """Template class for generating Lua code from templates."""
    
    def __init__(self, template: str):
        """Initialize with a template string."""
        self.template = template
        self._validate_template()
        
    def _validate_template(self) -> None:
        """Validate the template string for correct format."""
        try:
            # Check if template string is valid
            _ = string.Template(self.template)
        except (ValueError, KeyError) as e:
            raise ValueError(f"Invalid template format: {str(e)}")
    
    def render(self, context: Dict[str, Any]) -> str:
        """Render the template with the provided context."""
        try:
            template = string.Template(self.template)
            return template.substitute(context)
        except KeyError as e:
            raise KeyError(f"Missing required template variable: {str(e)}")
        except Exception as e:
            raise RuntimeError(f"Template rendering error: {str(e)}")


class TemplateLibrary:
    """Library of predefined Lua code templates."""
    
    def __init__(self):
        """Initialize the template library with predefined templates."""
        self._templates: Dict[str, LuaTemplate] = {}
        self._load_default_templates()
    
    def _load_default_templates(self) -> None:
        """Load default templates for common operations."""
        # Job management templates
        self._templates["create_job"] = LuaTemplate("""
local job = {}
job.width = ${width}
job.height = ${height}
job.material = "${material}"
job.thickness = ${thickness}
return VectricJob.Create(job)
        """)
        
        self._templates["open_job"] = LuaTemplate("""
return VectricJob.Open("${file_path}")
        """)
        
        self._templates["save_job"] = LuaTemplate("""
return VectricJob.Save("${file_path}")
        """)
        
        # Vector creation templates
        self._templates["create_circle"] = LuaTemplate("""
local circle = Circle.new()
circle:SetCentre(${center_x}, ${center_y})
circle:SetRadius(${radius})
return circle
        """)
        
        self._templates["create_rectangle"] = LuaTemplate("""
local rect = {}
rect.x1 = ${x1}
rect.y1 = ${y1}
rect.x2 = ${x2}
rect.y2 = ${y2}
return DrawingTool:DrawRectangle(rect.x1, rect.y1, rect.x2, rect.y2)
        """)
        
        self._templates["create_text"] = LuaTemplate("""
local text = Text.new()
text:SetFont("${font_name}", ${font_size}, ${bold}, ${italic})
text:SetText("${text_content}")
text:SetAlignment(${alignment})
text:DrawAtPosition(${position_x}, ${position_y})
return text
        """)
        
        # Toolpath templates
        self._templates["create_profile_toolpath"] = LuaTemplate("""
local toolpath = Toolpath.new()
toolpath:SetName("${name}")
toolpath:SetCutDepth(${cut_depth})
toolpath:SetTool(${tool_index})
toolpath:SetPassDepth(${pass_depth})
toolpath:SetDirection(${climb_cut})
toolpath:Calculate()
return toolpath
        """)
        
        self._templates["create_pocket_toolpath"] = LuaTemplate("""
local toolpath = Toolpath.new()
toolpath:SetName("${name}")
toolpath:SetCutDepth(${cut_depth})
toolpath:SetTool(${tool_index})
toolpath:SetPassDepth(${pass_depth})
toolpath:SetStepover(${stepover})
toolpath:Calculate()
return toolpath
        """)
        
        # Layer management templates
        self._templates["create_layer"] = LuaTemplate("""
local layer_manager = Job:GetLayerManager()
return layer_manager:AddNewLayer("${name}", ${color}, ${is_visible}, ${is_active})
        """)
        
        self._templates["set_active_layer"] = LuaTemplate("""
local layer_manager = Job:GetLayerManager()
return layer_manager:SetActiveLayer("${name}")
        """)
    
    def get_template(self, template_name: str) -> Optional[LuaTemplate]:
        """Get a template by name."""
        return self._templates.get(template_name)
    
    def add_template(self, name: str, template_str: str) -> None:
        """Add a new template or replace an existing one."""
        self._templates[name] = LuaTemplate(template_str)
    
    def list_templates(self) -> List[str]:
        """List all available template names."""
        return list(self._templates.keys())
