"""
Unit tests for the metrics module of the AiSpire MCP Server.

This module tests the performance metrics collection and reporting functionality.
"""

import unittest
import json
import time
from unittest.mock import patch, MagicMock
import sys
import os

# Add the parent directory to the path so we can import the metrics module
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from metrics import Metrics, initialize_metrics, get_metrics

class TestMetrics(unittest.TestCase):
    """Test cases for the Metrics class."""

    def setUp(self):
        """Set up test fixtures."""
        # Test configuration
        self.config = {
            "enabled": True,
            "history_size": 10,
            "reporting_interval": 0.1,  # Short interval for testing
            "alert_thresholds": {
                "request_latency": 100,
                "lua_execution_time": 500,
                "error_rate": 0.1,
                "connection_failures": 2
            }
        }
        
        # Create a new metrics instance for each test
        self.metrics = Metrics(self.config)
    
    def tearDown(self):
        """Tear down test fixtures."""
        # Shutdown the metrics reporting thread if it was started
        if hasattr(self, 'metrics'):
            self.metrics.shutdown()
    
    def test_initialization(self):
        """Test that the metrics object is initialized with correct config."""
        self.assertTrue(self.metrics.enabled)
        self.assertEqual(self.metrics.history_size, 10)
        self.assertEqual(self.metrics.reporting_interval, 0.1)
        self.assertEqual(self.metrics.alert_thresholds["request_latency"], 100)
        self.assertEqual(self.metrics.alert_thresholds["lua_execution_time"], 500)
        self.assertEqual(self.metrics.alert_thresholds["error_rate"], 0.1)
        self.assertEqual(self.metrics.alert_thresholds["connection_failures"], 2)
        
        # Check that internal structures are initialized
        self.assertEqual(self.metrics._summary["total_requests"], 0)
        self.assertEqual(self.metrics._summary["total_errors"], 0)
        self.assertEqual(self.metrics._summary["avg_request_latency"], 0)
    
    def test_record_request_latency(self):
        """Test recording request latency."""
        # Record some latencies
        self.metrics.record_request_latency(50.0)
        self.metrics.record_request_latency(60.0)
        
        # Check that they were recorded correctly
        self.assertEqual(self.metrics._current_period["request_count"], 2)
        self.assertEqual(self.metrics._summary["total_requests"], 2)
        self.assertEqual(len(self.metrics._request_latencies), 2)
        
        # Check that the summary contains the average latency
        summary = self.metrics.get_metrics_summary()
        self.assertEqual(summary["total_requests"], 2)
        self.assertEqual(summary["avg_request_latency_ms"], 55.0)
    
    def test_record_execution_time(self):
        """Test recording execution time."""
        # Record some execution times
        self.metrics.record_execution_time(100.0)
        self.metrics.record_execution_time(200.0)
        
        # Check that they were recorded correctly
        self.assertEqual(len(self.metrics._execution_times), 2)
        
        # Check that the summary contains the average execution time
        summary = self.metrics.get_metrics_summary()
        self.assertEqual(summary["avg_execution_time_ms"], 150.0)
    
    def test_record_error(self):
        """Test recording errors."""
        # Record some errors
        self.metrics.record_error("connection_error")
        self.metrics.record_error("parsing_error")
        
        # Check that they were recorded correctly
        self.assertEqual(self.metrics._current_period["error_count"], 2)
        self.assertEqual(self.metrics._summary["total_errors"], 2)
        self.assertEqual(len(self.metrics._error_counts), 2)
        
        # Check that the summary contains the error count
        summary = self.metrics.get_metrics_summary()
        self.assertEqual(summary["total_errors"], 2)
        
        # Now add some requests to check error rate calculation
        self.metrics.record_request_latency(50.0)
        self.metrics.record_request_latency(60.0)
        
        # Check the error rate (2 errors / 2 requests = 100%)
        summary = self.metrics.get_metrics_summary()
        self.assertEqual(summary["error_rate"], 1.0)  # 100% error rate
    
    def test_record_connection_attempt(self):
        """Test recording connection attempts."""
        # Record some connection attempts
        self.metrics.record_connection_attempt(True)
        self.metrics.record_connection_attempt(False)
        self.metrics.record_connection_attempt(True)
        
        # Check that they were recorded correctly
        self.assertEqual(self.metrics._current_period["connection_attempt_count"], 3)
        self.assertEqual(self.metrics._current_period["connection_failure_count"], 1)
        self.assertEqual(self.metrics._summary["total_connection_attempts"], 3)
        self.assertEqual(self.metrics._summary["total_connection_failures"], 1)
        self.assertEqual(len(self.metrics._connection_attempts), 3)
        self.assertEqual(len(self.metrics._connection_failures), 1)
        
        # Check that the summary contains the connection counts
        summary = self.metrics.get_metrics_summary()
        self.assertEqual(summary["total_connection_attempts"], 3)
        self.assertEqual(summary["total_connection_failures"], 1)
    
    def test_reset_period_metrics(self):
        """Test resetting period metrics."""
        # Add some metrics
        self.metrics.record_request_latency(50.0)
        self.metrics.record_error("connection_error")
        self.metrics.record_connection_attempt(False)
        
        # Check that period metrics are present
        self.assertEqual(self.metrics._current_period["request_count"], 1)
        self.assertEqual(self.metrics._current_period["error_count"], 1)
        self.assertEqual(self.metrics._current_period["connection_attempt_count"], 1)
        self.assertEqual(self.metrics._current_period["connection_failure_count"], 1)
        
        # Reset period metrics
        self.metrics.reset_period_metrics()
        
        # Check that period metrics are reset but total metrics are preserved
        self.assertEqual(self.metrics._current_period["request_count"], 0)
        self.assertEqual(self.metrics._current_period["error_count"], 0)
        self.assertEqual(self.metrics._current_period["connection_attempt_count"], 0)
        self.assertEqual(self.metrics._current_period["connection_failure_count"], 0)
        self.assertEqual(self.metrics._summary["total_requests"], 1)
        self.assertEqual(self.metrics._summary["total_errors"], 1)
    
    def test_export_metrics_json(self):
        """Test exporting metrics as JSON."""
        # Add some metrics
        self.metrics.record_request_latency(50.0)
        self.metrics.record_error("connection_error")
        
        # Export as JSON and check the result
        json_str = self.metrics.export_metrics_json()
        metrics_dict = json.loads(json_str)
        
        self.assertEqual(metrics_dict["total_requests"], 1)
        self.assertEqual(metrics_dict["total_errors"], 1)
        self.assertEqual(metrics_dict["avg_request_latency_ms"], 50.0)
    
    def test_export_metrics_prometheus(self):
        """Test exporting metrics in Prometheus format."""
        # Add some metrics
        self.metrics.record_request_latency(50.0)
        self.metrics.record_error("connection_error")
        
        # Export in Prometheus format and check the result
        prom_str = self.metrics.export_metrics_prometheus()
        
        self.assertIn("aispire_mcp_requests_total 1", prom_str)
        self.assertIn("aispire_mcp_errors_total 1", prom_str)
        self.assertIn("aispire_mcp_request_latency_ms 50.0", prom_str)
    
    @patch('logging.Logger.warning')
    def test_alert_thresholds(self, mock_warning):
        """Test that alerts are triggered when thresholds are exceeded."""
        # Test high latency alert
        self.metrics.record_request_latency(150.0)  # Above the 100ms threshold
        mock_warning.assert_called_with("High request latency detected: 150.0ms (threshold: 100ms)")
        mock_warning.reset_mock()
        
        # Test long execution time alert
        self.metrics.record_execution_time(600.0)  # Above the 500ms threshold
        mock_warning.assert_called_with("Long execution time detected: 600.0ms (threshold: 500ms)")
        mock_warning.reset_mock()
        
        # Test high error rate alert
        # First, add enough requests to make error rate meaningful
        self.metrics.record_request_latency(50.0)
        self.metrics.record_request_latency(50.0)
        self.metrics.record_request_latency(50.0)
        self.metrics.record_request_latency(50.0)
        self.metrics.record_request_latency(50.0)
        
        # Now add enough errors to exceed threshold
        self.metrics.record_error("error1")  # 1/6 = ~16.7% error rate
        mock_warning.assert_called_with("High error rate detected: 16.67% (threshold: 10.00%)")
        mock_warning.reset_mock()
    
    def test_history_size_limit(self):
        """Test that history is limited to the configured size."""
        # Configure a small history size
        self.metrics.history_size = 3
        
        # Record more items than the history size
        for i in range(5):
            self.metrics.record_request_latency(50.0 + i)
        
        # Check that only the most recent items are kept
        self.assertEqual(len(self.metrics._request_latencies), 3)
        
        # Check that the correct items are kept (the most recent ones)
        latencies = [l for _, l in self.metrics._request_latencies]
        self.assertEqual(latencies, [52.0, 53.0, 54.0])
        
    @patch('logging.Logger.info')
    def test_periodic_reporting(self, mock_info):
        """Test that metrics are periodically reported."""
        # Configure a short reporting interval
        self.metrics.reporting_interval = 0.1
        
        # Add some metrics
        self.metrics.record_request_latency(50.0)
        self.metrics.record_error("connection_error")
        
        # Sleep to allow the reporting thread to run
        time.sleep(0.2)
        
        # Check that the metrics were reported
        mock_info.assert_any_call(
            "Metrics summary: Requests: 1, Errors: 1, Avg Latency: 50.0ms, Error Rate: 100.00%"
        )
        
        # Check that period metrics were reset
        self.assertEqual(self.metrics._current_period["request_count"], 0)
        self.assertEqual(self.metrics._current_period["error_count"], 0)

    def test_singleton_initialization(self):
        """Test initializing and retrieving the metrics singleton."""
        # Initialize the singleton
        metrics = initialize_metrics(self.config)
        self.assertIsNotNone(metrics)
        self.assertTrue(metrics.enabled)
        
        # Get the singleton
        same_metrics = get_metrics()
        self.assertIs(same_metrics, metrics)
        
        # Calling initialize_metrics again should return the same instance
        same_metrics_again = initialize_metrics({"enabled": False})
        self.assertIs(same_metrics_again, metrics)
        self.assertTrue(metrics.enabled)  # Config shouldn't change on second init
        
        # Cleanup
        metrics.shutdown()


if __name__ == '__main__':
    unittest.main()