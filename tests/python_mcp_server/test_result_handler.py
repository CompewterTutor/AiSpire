"""
Tests for the ResultHandler module.
"""
import json
import unittest

from python_mcp_server.result_handler import ResultHandler, ResultType, ErrorCategory


class TestResultHandler(unittest.TestCase):
    """Test cases for the ResultHandler class."""

    def test_parse_response_valid_json(self):
        """Test parsing a valid JSON response."""
        response = '{"status": "success", "result": {"data": "test", "message": "Test message"}}'
        parsed = ResultHandler.parse_response(response)
        self.assertEqual(parsed["status"], "success")
        self.assertEqual(parsed["result"]["data"], "test")
        self.assertEqual(parsed["result"]["message"], "Test message")

    def test_parse_response_invalid_json(self):
        """Test parsing an invalid JSON response."""
        response = 'this is not valid json'
        parsed = ResultHandler.parse_response(response)
        self.assertEqual(parsed["status"], "error")
        self.assertIn("Invalid JSON response", parsed["result"]["message"])
        self.assertEqual(parsed["result"]["type"], "syntax_error")

    def test_format_success_response(self):
        """Test formatting a success response."""
        data = {"key": "value"}
        response = ResultHandler.format_success_response(
            data=data,
            message="Operation successful",
            command_id="cmd123",
            execution_time=150
        )
        self.assertEqual(response["status"], "success")
        self.assertEqual(response["result"]["data"], data)
        self.assertEqual(response["result"]["message"], "Operation successful")
        self.assertEqual(response["command_id"], "cmd123")
        self.assertEqual(response["execution_time"], 150)

    def test_format_error_response(self):
        """Test formatting an error response."""
        response = ResultHandler.format_error_response(
            message="Something went wrong",
            category=ErrorCategory.RUNTIME,
            data={"error_details": "Stack trace"},
            command_id="cmd123",
            execution_time=150
        )
        self.assertEqual(response["status"], "error")
        self.assertEqual(response["result"]["message"], "Something went wrong")
        self.assertEqual(response["result"]["type"], "runtime_error")
        self.assertEqual(response["result"]["data"], {"error_details": "Stack trace"})
        self.assertEqual(response["command_id"], "cmd123")
        self.assertEqual(response["execution_time"], 150)

    def test_format_in_progress_response(self):
        """Test formatting an in-progress response."""
        response = ResultHandler.format_in_progress_response(
            progress=0.75,
            message="Processing data",
            command_id="cmd123"
        )
        self.assertEqual(response["status"], "in_progress")
        self.assertEqual(response["result"]["data"]["progress"], 0.75)
        self.assertEqual(response["result"]["message"], "Processing data")
        self.assertEqual(response["command_id"], "cmd123")
        self.assertIsNone(response["execution_time"])

    def test_format_info_response(self):
        """Test formatting an info response."""
        response = ResultHandler.format_info_response(
            message="Informational message",
            data={"details": "Some info"},
            command_id="cmd123"
        )
        self.assertEqual(response["status"], "info")
        self.assertEqual(response["result"]["message"], "Informational message")
        self.assertEqual(response["result"]["data"], {"details": "Some info"})
        self.assertEqual(response["command_id"], "cmd123")

    def test_format_warning_response(self):
        """Test formatting a warning response."""
        response = ResultHandler.format_warning_response(
            message="Warning message",
            data={"details": "Some warning"},
            command_id="cmd123"
        )
        self.assertEqual(response["status"], "warning")
        self.assertEqual(response["result"]["message"], "Warning message")
        self.assertEqual(response["result"]["data"], {"details": "Some warning"})
        self.assertEqual(response["command_id"], "cmd123")

    def test_categorize_error(self):
        """Test error categorization based on message content."""
        self.assertEqual(
            ResultHandler.categorize_error("Syntax error in line 5"),
            ErrorCategory.SYNTAX
        )
        self.assertEqual(
            ResultHandler.categorize_error("Connection refused"),
            ErrorCategory.CONNECTION
        )
        self.assertEqual(
            ResultHandler.categorize_error("Permission denied"),
            ErrorCategory.PERMISSION
        )
        self.assertEqual(
            ResultHandler.categorize_error("Operation timed out"),
            ErrorCategory.TIMEOUT
        )
        self.assertEqual(
            ResultHandler.categorize_error("Invalid argument"),
            ErrorCategory.VALIDATION
        )
        self.assertEqual(
            ResultHandler.categorize_error("Out of memory"),
            ErrorCategory.RESOURCE
        )
        self.assertEqual(
            ResultHandler.categorize_error("Runtime exception"),
            ErrorCategory.RUNTIME
        )
        self.assertEqual(
            ResultHandler.categorize_error("Something else happened"),
            ErrorCategory.UNKNOWN
        )

    def test_process_lua_response_success(self):
        """Test processing a success response from Lua."""
        lua_response = {
            "status": "success",
            "result": {
                "data": {"value": 42},
                "message": "Calculation complete"
            },
            "execution_time": 120
        }
        processed = ResultHandler.process_lua_response(lua_response, "cmd456")
        self.assertEqual(processed["status"], "success")
        self.assertEqual(processed["result"]["data"], {"value": 42})
        self.assertEqual(processed["result"]["message"], "Calculation complete")
        self.assertEqual(processed["command_id"], "cmd456")
        self.assertEqual(processed["execution_time"], 120)

    def test_process_lua_response_error(self):
        """Test processing an error response from Lua."""
        lua_response = {
            "status": "error",
            "result": {
                "message": "Failed to execute script",
                "type": "runtime_error",
                "data": {"line": 10}
            },
            "execution_time": 50
        }
        processed = ResultHandler.process_lua_response(lua_response, "cmd789")
        self.assertEqual(processed["status"], "error")
        self.assertEqual(processed["result"]["message"], "Failed to execute script")
        self.assertEqual(processed["result"]["type"], "runtime_error")
        self.assertEqual(processed["result"]["data"], {"line": 10})
        self.assertEqual(processed["command_id"], "cmd789")
        self.assertEqual(processed["execution_time"], 50)

    def test_process_lua_response_in_progress(self):
        """Test processing an in-progress response from Lua."""
        lua_response = {
            "status": "in_progress",
            "result": {
                "data": {"progress": 0.5},
                "message": "Halfway there"
            }
        }
        processed = ResultHandler.process_lua_response(lua_response, "cmd101")
        self.assertEqual(processed["status"], "in_progress")
        self.assertEqual(processed["result"]["data"]["progress"], 0.5)
        self.assertEqual(processed["result"]["message"], "Halfway there")
        self.assertEqual(processed["command_id"], "cmd101")

    def test_process_lua_response_unknown_status(self):
        """Test processing a response with unknown status."""
        lua_response = {
            "status": "something_else",
            "result": {
                "data": {},
                "message": "Unknown operation"
            }
        }
        processed = ResultHandler.process_lua_response(lua_response, "cmd202")
        self.assertEqual(processed["status"], "error")
        self.assertIn("Unknown response status", processed["result"]["message"])
        self.assertEqual(processed["result"]["type"], "unknown_error")
        self.assertEqual(processed["command_id"], "cmd202")


if __name__ == '__main__':
    unittest.main()
