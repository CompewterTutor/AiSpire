"""
Tests for command templates.

This module contains tests for the command template system
that generates Lua code for common Vectric operations.
"""

import unittest
import json

from python_mcp_server.command_generation.templates import (
    JobTemplates,
    VectorTemplates,
    ToolpathTemplates,
    LayerTemplates
)


class TestJobTemplates(unittest.TestCase):
    """Tests for job management templates."""
    
    def test_create_new_job(self):
        """Test create_new_job template."""
        lua_code = JobTemplates.create_new_job(
            name="Test Job",
            width=200.0,
            height=150.0,
            thickness=25.0,
            in_mm=True,
            origin_on_surface=True
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('CreateNewJob("Test Job"', lua_code)
        self.assertIn('Box2D(0, 0, 200.0, 150.0)', lua_code)
        self.assertIn('25.0', lua_code)
        self.assertIn('true', lua_code)
    
    def test_open_job(self):
        """Test open_job template."""
        lua_code = JobTemplates.open_job(file_path="/path/to/job.crv")
        self.assertIsInstance(lua_code, str)
        self.assertIn('OpenExistingJob("/path/to/job.crv")', lua_code)
    
    def test_save_job(self):
        """Test save_job template."""
        lua_code = JobTemplates.save_job()
        self.assertIsInstance(lua_code, str)
        self.assertIn('SaveCurrentJob()', lua_code)
    
    def test_get_job_properties(self):
        """Test get_job_properties template."""
        lua_code = JobTemplates.get_job_properties()
        self.assertIsInstance(lua_code, str)
        self.assertIn('GetJobName()', lua_code)
        self.assertIn('GetMaterialThickness()', lua_code)
        self.assertIn('GetMaterialBlock()', lua_code)


class TestVectorTemplates(unittest.TestCase):
    """Tests for vector manipulation templates."""
    
    def test_create_circle(self):
        """Test create_circle template."""
        lua_code = VectorTemplates.create_circle(
            center_x=100.0,
            center_y=100.0,
            radius=50.0,
            layer_name="Circles Layer"
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('Circle(100.0, 100.0, 50.0)', lua_code)
        self.assertIn('AddVectorToJob(circle, "Circles Layer")', lua_code)
    
    def test_create_rectangle(self):
        """Test create_rectangle template."""
        lua_code = VectorTemplates.create_rectangle(
            x=50.0,
            y=50.0,
            width=100.0,
            height=75.0,
            corner_radius=5.0,
            layer_name="Rectangles Layer"
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('CreateRoundedRectangle(50.0, 50.0, 100.0, 75.0, 5.0)', lua_code)
        self.assertIn('AddVectorToJob(rect, "Rectangles Layer")', lua_code)
    
    def test_create_text(self):
        """Test create_text template."""
        lua_code = VectorTemplates.create_text(
            text="Hello World",
            x=100.0,
            y=100.0,
            font_name="Arial",
            font_size=24.0,
            height=5.0,
            bold=True,
            italic=False,
            alignment="Center"
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('CreateText("Hello World", 24.0, "Arial", true, false, TextAlignment.CENTER)', lua_code)
        self.assertIn('text_obj:SetHeight(5.0)', lua_code)
        self.assertIn('text_obj:MoveTo(100.0, 100.0)', lua_code)
    
    def test_boolean_operation(self):
        """Test boolean_operation template."""
        lua_code = VectorTemplates.boolean_operation(
            vector_ids=[1, 2, 3],
            operation="Union",
            layer_name="Boolean Results"
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('local vector_ids = {1, 2, 3}', lua_code)
        self.assertIn('BooleanOperation.UNION', lua_code)
        self.assertIn('AddVectorToJob(result, "Boolean Results")', lua_code)


class TestToolpathTemplates(unittest.TestCase):
    """Tests for toolpath templates."""
    
    def test_create_profile_toolpath(self):
        """Test create_profile_toolpath template."""
        lua_code = ToolpathTemplates.create_profile_toolpath(
            vector_ids=[1, 2, 3],
            tool_id=5,
            name="Test Profile",
            cut_depth=10.0,
            cut_inside=True,
            allowance=0.1
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('local vector_ids = {1, 2, 3}', lua_code)
        self.assertIn('GetToolById(5)', lua_code)
        self.assertIn('name = "Test Profile"', lua_code)
        self.assertIn('cut_depth = 10.0', lua_code)
        self.assertIn('side = ProfileToolpathSide.INSIDE', lua_code)
        self.assertIn('allowance = 0.1', lua_code)
    
    def test_create_pocket_toolpath(self):
        """Test create_pocket_toolpath template."""
        lua_code = ToolpathTemplates.create_pocket_toolpath(
            vector_ids=[1, 2],
            tool_id=6,
            name="Test Pocket",
            cut_depth=15.0,
            stepover=2.5,
            clearing_strategy="Offset",
            profile_pass=True
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('local vector_ids = {1, 2}', lua_code)
        self.assertIn('GetToolById(6)', lua_code)
        self.assertIn('name = "Test Pocket"', lua_code)
        self.assertIn('cut_depth = 15.0', lua_code)
        self.assertIn('strategy = PocketStrategy.OFFSET', lua_code)
        self.assertIn('stepover = 2.5', lua_code)
        self.assertIn('profile_pass = true', lua_code)
    
    def test_create_drilling_toolpath(self):
        """Test create_drilling_toolpath template."""
        lua_code = ToolpathTemplates.create_drilling_toolpath(
            point_ids=[10, 11, 12],
            tool_id=3,
            name="Test Drilling",
            cut_depth=20.0,
            dwell=0.5,
            peck_depth=2.0
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('local point_ids = {10, 11, 12}', lua_code)
        self.assertIn('GetToolById(3)', lua_code)
        self.assertIn('name = "Test Drilling"', lua_code)
        self.assertIn('cut_depth = 20.0', lua_code)
        self.assertIn('dwell = 0.5', lua_code)
        self.assertIn('peck_depth = 2.0', lua_code)


class TestLayerTemplates(unittest.TestCase):
    """Tests for layer management templates."""
    
    def test_create_layer(self):
        """Test create_layer template."""
        lua_code = LayerTemplates.create_layer(
            name="Test Layer",
            visible=True,
            locked=False
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('CreateLayer("Test Layer")', lua_code)
        self.assertIn('layer:SetVisible(true)', lua_code)
        self.assertIn('layer:SetLocked(false)', lua_code)
    
    def test_get_layer(self):
        """Test get_layer template."""
        lua_code = LayerTemplates.get_layer(name="Test Layer")
        self.assertIsInstance(lua_code, str)
        self.assertIn('GetLayerByName("Test Layer")', lua_code)
        self.assertIn('properties.name = layer:GetName()', lua_code)
        self.assertIn('properties.visible = layer:IsVisible()', lua_code)
    
    def test_rename_layer(self):
        """Test rename_layer template."""
        lua_code = LayerTemplates.rename_layer(
            old_name="Old Layer",
            new_name="New Layer"
        )
        self.assertIsInstance(lua_code, str)
        self.assertIn('GetLayerByName("Old Layer")', lua_code)
        self.assertIn('GetLayerByName("New Layer")', lua_code)
        self.assertIn('layer:SetName("New Layer")', lua_code)
    
    def test_list_all_layers(self):
        """Test list_all_layers template."""
        lua_code = LayerTemplates.list_all_layers()
        self.assertIsInstance(lua_code, str)
        self.assertIn('GetAllLayers()', lua_code)
        self.assertIn('properties.name = layer:GetName()', lua_code)
        self.assertIn('properties.visible = layer:IsVisible()', lua_code)
        self.assertIn('properties.locked = layer:IsLocked()', lua_code)


if __name__ == '__main__':
    unittest.main()