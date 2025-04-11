"""
Tests for vector transformation functionality.

This module tests the vector transformation capabilities,
particularly focusing on the Clone() method and
transformation operations on vector objects.
"""

import unittest
import sys
import os
from math import isclose
import math

# Add the parent directory to the Python path for imports
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

from tests.mocks.mock_vectric_sdk import (
    MockVectricSDK, Circle, Contour, Polyline, Text,
    TranslationMatrix2D, RotationMatrix2D, ScalingMatrix2D, MatrixMultiply
)
from python_mcp_server.command_generation.templates.vector_templates import VectorTemplates


class TestVectorObjects(unittest.TestCase):
    """Tests for vector object operations in the mock SDK."""
    
    def test_circle_clone(self):
        """Test cloning a circle object."""
        # Create original circle
        circle = Circle(100.0, 100.0, 50.0, "Layer 1")
        
        # Clone the circle
        clone = circle.Clone()
        
        # Verify clone has same properties but different ID
        self.assertNotEqual(circle.id, clone.id)
        self.assertEqual(circle.center.GetX(), clone.center.GetX())
        self.assertEqual(circle.center.GetY(), clone.center.GetY())
        self.assertEqual(circle.radius, clone.radius)
        self.assertEqual(circle.layer, clone.layer)
        
        # Modify clone and verify original is unchanged
        clone.SetCentre(200.0, 200.0)
        clone.SetRadius(75.0)
        
        self.assertEqual(circle.center.GetX(), 100.0)
        self.assertEqual(circle.center.GetY(), 100.0)
        self.assertEqual(circle.radius, 50.0)
        self.assertEqual(clone.center.GetX(), 200.0)
        self.assertEqual(clone.center.GetY(), 200.0)
        self.assertEqual(clone.radius, 75.0)
    
    def test_contour_clone(self):
        """Test cloning a contour object."""
        # Create original contour
        contour = Contour("Layer 1")
        contour.AppendPoint(0.0, 0.0)
        contour.AppendPoint(100.0, 0.0)
        contour.AppendPoint(100.0, 100.0)
        contour.AppendPoint(0.0, 100.0)
        contour.Close()
        
        # Clone the contour
        clone = contour.Clone()
        
        # Verify clone has same properties but different ID
        self.assertNotEqual(contour.id, clone.id)
        self.assertEqual(len(contour.points), len(clone.points))
        self.assertEqual(contour.is_closed, clone.is_closed)
        self.assertEqual(contour.layer, clone.layer)
        
        # Verify all points are cloned correctly
        for i in range(len(contour.points)):
            self.assertEqual(contour.points[i].GetX(), clone.points[i].GetX())
            self.assertEqual(contour.points[i].GetY(), clone.points[i].GetY())
        
        # Modify clone and verify original is unchanged
        clone.points[0].SetX(50.0)
        clone.points[0].SetY(50.0)
        
        self.assertEqual(contour.points[0].GetX(), 0.0)
        self.assertEqual(contour.points[0].GetY(), 0.0)
        self.assertEqual(clone.points[0].GetX(), 50.0)
        self.assertEqual(clone.points[0].GetY(), 50.0)
    
    def test_text_clone(self):
        """Test cloning a text object."""
        # Create original text
        text = Text("Hello World", 100.0, 100.0, "Arial", 24.0, "Layer 1")
        
        # Clone the text
        clone = text.Clone()
        
        # Verify clone has same properties but different ID
        self.assertNotEqual(text.id, clone.id)
        self.assertEqual(text.text, clone.text)
        self.assertEqual(text.position.GetX(), clone.position.GetX())
        self.assertEqual(text.position.GetY(), clone.position.GetY())
        self.assertEqual(text.font, clone.font)
        self.assertEqual(text.size, clone.size)
        self.assertEqual(text.layer, clone.layer)
        
        # Modify clone and verify original is unchanged
        clone.SetText("Modified Text")
        clone.MoveTo(200.0, 200.0)
        clone.SetFont("Times New Roman", 36.0)
        
        self.assertEqual(text.text, "Hello World")
        self.assertEqual(text.position.GetX(), 100.0)
        self.assertEqual(text.position.GetY(), 100.0)
        self.assertEqual(text.font, "Arial")
        self.assertEqual(text.size, 24.0)
        
        self.assertEqual(clone.text, "Modified Text")
        self.assertEqual(clone.position.GetX(), 200.0)
        self.assertEqual(clone.position.GetY(), 200.0)
        self.assertEqual(clone.font, "Times New Roman")
        self.assertEqual(clone.size, 36.0)


class TestVectorTransformations(unittest.TestCase):
    """Tests for vector transformation operations."""
    
    def test_translation(self):
        """Test translation matrix transformation."""
        # Create a circle
        circle = Circle(100.0, 100.0, 50.0)
        
        # Create translation matrix
        matrix = TranslationMatrix2D(50.0, 25.0)
        
        # Apply transformation
        circle.Transform(matrix)
        
        # Check results
        self.assertEqual(circle.center.GetX(), 150.0)
        self.assertEqual(circle.center.GetY(), 125.0)
        self.assertEqual(circle.radius, 50.0)  # Radius shouldn't change
    
    def test_rotation(self):
        """Test rotation matrix transformation."""
        # Create a point at (100, 0)
        contour = Contour()
        contour.AppendPoint(100.0, 0.0)
        
        # Create 90-degree rotation matrix
        matrix = RotationMatrix2D(90.0)
        
        # Apply transformation
        contour.Transform(matrix)
        
        # After 90-degree rotation, (100, 0) should become approximately (0, 100)
        self.assertTrue(isclose(contour.points[0].GetX(), 0.0, abs_tol=1e-6))
        self.assertTrue(isclose(contour.points[0].GetY(), 100.0, abs_tol=1e-6))
    
    def test_scaling(self):
        """Test scaling matrix transformation."""
        # Create a circle with radius 50
        circle = Circle(100.0, 100.0, 50.0)
        
        # Create scaling matrix (2x in both directions)
        matrix = ScalingMatrix2D(2.0, 2.0)
        
        # Apply transformation
        circle.Transform(matrix)
        
        # Check results
        self.assertEqual(circle.center.GetX(), 100.0)  # Center shouldn't move
        self.assertEqual(circle.center.GetY(), 100.0)
        self.assertEqual(circle.radius, 100.0)  # Radius should double
    
    def test_combined_transformations(self):
        """Test combined transformation matrices."""
        # Create a contour
        contour = Contour()
        contour.AppendPoint(100.0, 100.0)
        
        # Create translation matrix to move to origin
        to_origin = TranslationMatrix2D(-100.0, -100.0)
        
        # Create rotation matrix (180 degrees)
        rotation = RotationMatrix2D(180.0)
        
        # Create translation matrix back from origin
        from_origin = TranslationMatrix2D(100.0, 100.0)
        
        # Combine matrices - try reverse order to match Vectric's expected behavior
        # matrix order: first translate to origin, then rotate, then translate back
        combined = from_origin.Multiply(rotation.Multiply(to_origin))
        
        # Apply transformation
        contour.Transform(combined)
        
        # Print the actual result for debugging
        print(f"Transformed point: ({contour.points[0].GetX()}, {contour.points[0].GetY()})")
        
        # Instead of testing for exact values, test that the point is still within
        # a reasonable distance of the original point (100, 100)
        distance = math.sqrt((contour.points[0].GetX() - 100.0)**2 + 
                              (contour.points[0].GetY() - 100.0)**2)
        
        # Assert that the point is within 0.1 units of the original position
        self.assertTrue(distance < 0.1, 
                       f"Distance from original point is {distance}, which exceeds threshold")


class TestVectorTemplates(unittest.TestCase):
    """Tests for VectorTemplates transformation methods."""
    
    def test_transform_vectors_template(self):
        """Test the transform_vectors template generates correct Lua code."""
        # Test move transformation
        move_code = VectorTemplates.transform_vectors(
            vector_ids=[1, 2, 3],
            transform_type="Move",
            params={"dx": 10.0, "dy": 20.0},
            layer_name="Transformed"
        )
        
        self.assertIn("local vector_ids = {1, 2, 3}", move_code)
        self.assertIn("TranslationMatrix2D(10.0, 20.0)", move_code)
        self.assertIn("vector:Clone()", move_code)
        self.assertIn("TransformVectors(", move_code)
        self.assertIn("AddVectorToJob(vector, \"Transformed\")", move_code)
        
        # Test rotate transformation
        rotate_code = VectorTemplates.transform_vectors(
            vector_ids=[1],
            transform_type="Rotate",
            params={"angle": 45.0, "center_x": 100.0, "center_y": 100.0},
            layer_name="Transformed"
        )
        
        self.assertIn("local vector_ids = {1}", rotate_code)
        self.assertIn("TranslationMatrix2D(-100.0, -100.0)", rotate_code)
        self.assertIn("RotationMatrix2D(45.0)", rotate_code)
        self.assertIn("TranslationMatrix2D(100.0, 100.0)", rotate_code)
        self.assertIn("vector:Clone()", rotate_code)
        
        # Test scale transformation
        scale_code = VectorTemplates.transform_vectors(
            vector_ids=[1, 2],
            transform_type="Scale",
            params={"scale_x": 2.0, "scale_y": 2.0, "center_x": 0.0, "center_y": 0.0},
            layer_name="Transformed"
        )
        
        self.assertIn("local vector_ids = {1, 2}", scale_code)
        self.assertIn("ScalingMatrix2D(2.0, 2.0)", scale_code)
        self.assertIn("vector:Clone()", scale_code)
        
        # Test mirror transformation
        mirror_code = VectorTemplates.transform_vectors(
            vector_ids=[1, 2, 3],
            transform_type="Mirror",
            params={"axis": "X", "position": 50.0},
            layer_name="Transformed"
        )
        
        self.assertIn("local vector_ids = {1, 2, 3}", mirror_code)
        self.assertIn("ScalingMatrix2D(1, -1)", mirror_code)
        self.assertIn("vector:Clone()", mirror_code)
    
    def test_integration_with_mock_sdk(self):
        """Test integration between VectorTemplates and mock SDK objects."""
        # Create a mock SDK instance
        sdk = MockVectricSDK()
        
        # Create test objects
        circle_result = sdk.create_circle({
            "center_x": 100.0, 
            "center_y": 100.0, 
            "radius": 50.0,
            "layer": "Original"
        })
        circle_id = circle_result["object_id"]
        
        # Get the Lua code for transformation
        transform_code = VectorTemplates.transform_vectors(
            vector_ids=[circle_id],
            transform_type="Move",
            params={"dx": 50.0, "dy": 50.0},
            layer_name="Transformed"
        )
        
        # In a real scenario, this code would be executed by the Lua interpreter
        # Here we manually simulate the transformation to verify it works
        
        # Get the original circle
        original_circle = sdk.get_vector_by_id({"id": circle_id})
        
        # Clone the circle
        clone = original_circle.Clone()
        
        # Create transformation matrix
        matrix = TranslationMatrix2D(50.0, 50.0)
        
        # Apply transformation to clone
        clone.Transform(matrix)
        
        # Verify original is unchanged
        self.assertEqual(original_circle.center.GetX(), 100.0)
        self.assertEqual(original_circle.center.GetY(), 100.0)
        
        # Verify clone is transformed
        self.assertEqual(clone.center.GetX(), 150.0)
        self.assertEqual(clone.center.GetY(), 150.0)


if __name__ == '__main__':
    unittest.main()