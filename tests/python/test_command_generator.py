"""
Tests for the command generator module.
"""
import pytest
from python_mcp_server.command_generation import CommandGenerator


class TestCommandGenerator:
    """Tests for the CommandGenerator class."""
    
    def setup_method(self):
        """Set up a command generator for testing."""
        self.generator = CommandGenerator()
    
    def test_generate_command_with_valid_template(self):
        """Test generating a command from a valid template."""
        success, cmd, error = self.generator.generate_command(
            "create_circle", 
            {"center_x": 100, "center_y": 100, "radius": 50}
        )
        
        assert success is True
        assert error is None
        assert "circle:SetCentre(100, 100)" in cmd
        assert "circle:SetRadius(50)" in cmd
    
    def test_generate_command_with_invalid_template(self):
        """Test generating a command with a non-existent template."""
        success, cmd, error = self.generator.generate_command(
            "non_existent_template", 
            {"param1": "value1"}
        )
        
        assert success is False
        assert cmd == ""
        assert "not found" in error
    
    def test_generate_custom_command_valid(self):
        """Test generating a command from a custom template string."""
        template = "local x = ${value}; return x * 2"
        success, cmd, error = self.generator.generate_custom_command(
            template, {"value": 10}
        )
        
        assert success is True
        assert error is None
        assert cmd == "local x = 10; return x * 2"
    
    def test_generate_custom_command_invalid(self):
        """Test generating a command from an invalid custom template."""
        template = "local function evil() os.execute('rm -rf /'); end; evil()"
        success, cmd, error = self.generator.generate_custom_command(
            template, {}
        )
        
        assert success is False
        assert "harmful operation" in error.lower()
    
    def test_generate_raw_command_valid(self):
        """Test validating a raw Lua command."""
        command = "local x = 10; return x * 2"
        success, cmd, error = self.generator.generate_raw_command(command)
        
        assert success is True
        assert error is None
        assert cmd == command
    
    def test_generate_raw_command_invalid(self):
        """Test validating an invalid raw Lua command."""
        command = "local x = 10; return x * 2; }"  # Unbalanced bracket
        success, cmd, error = self.generator.generate_raw_command(command)
        
        assert success is False
        assert "bracket" in error.lower()
    
    def test_add_custom_template(self):
        """Test adding a custom template to the library."""
        template = "return ${value} * 2"
        success, error = self.generator.add_custom_template("test_template", template)
        
        assert success is True
        assert error is None
        
        # Verify the template was added
        assert "test_template" in self.generator.list_available_templates()
        
        # Test using the newly added template
        success, cmd, error = self.generator.generate_command(
            "test_template", {"value": 10}
        )
        
        assert success is True
        assert cmd == "return 10 * 2"
