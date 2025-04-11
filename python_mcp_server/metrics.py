"""
Performance metrics module for AiSpire MCP Server.

This module provides functionality for collecting, storing, and exposing
performance metrics for the AiSpire MCP Server.
"""

import time
import threading
import logging
from typing import Dict, List, Any, Optional, Tuple
from collections import deque
import json

# Configure logging
logger = logging.getLogger("aispire_mcp.metrics")

class Metrics:
    """
    Collects and manages performance metrics for the AiSpire MCP Server.
    
    This class provides methods for recording various performance metrics,
    such as request latency, command execution time, and resource usage.
    It also supports periodic reporting and alerting when metrics exceed
    defined thresholds.
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize the metrics collector.
        
        Args:
            config: Configuration dictionary with metrics settings
        """
        self.enabled = config.get("enabled", True)
        self._history_size = config.get("history_size", 1000)
        self.reporting_interval = config.get("reporting_interval", 60)  # in seconds
        self.alert_thresholds = config.get("alert_thresholds", {
            "request_latency": 1000,  # ms
            "lua_execution_time": 5000,  # ms
            "error_rate": 0.05,  # 5%
            "connection_failures": 5  # count within reporting interval
        })
        
        # Metrics storage - create with correct maxlen
        self._request_latencies = deque(maxlen=self._history_size)
        self._execution_times = deque(maxlen=self._history_size)
        self._error_counts = deque(maxlen=self._history_size)
        self._connection_attempts = deque(maxlen=self._history_size)
        self._connection_failures = deque(maxlen=self._history_size)
        
        # Current period metrics (reset on each report)
        self._current_period = {
            "start_time": time.time(),
            "request_count": 0,
            "error_count": 0,
            "connection_attempt_count": 0,
            "connection_failure_count": 0,
        }
        
        # Summary statistics
        self._summary = {
            "total_requests": 0,
            "total_errors": 0,
            "total_connection_attempts": 0,
            "total_connection_failures": 0,
            "avg_request_latency": 0,
            "avg_execution_time": 0,
            "error_rate": 0,
        }
        
        # Lock for thread safety
        self._lock = threading.RLock()
        
        # Start reporting thread if enabled
        self._stop_reporting = threading.Event()
        if self.enabled and self.reporting_interval > 0:
            self._reporting_thread = threading.Thread(
                target=self._periodic_report, 
                daemon=True
            )
            self._reporting_thread.start()
        else:
            self._reporting_thread = None
    
    @property
    def history_size(self) -> int:
        """Get the history size limit."""
        return self._history_size
    
    @history_size.setter
    def history_size(self, value: int) -> None:
        """
        Set the history size limit and update all deque maxlengths.
        
        Args:
            value: New history size
        """
        self._history_size = value
        
        # Update all deque maxlengths
        with self._lock:
            # Create new deques with the updated maxlen
            new_request_latencies = deque(self._request_latencies, maxlen=value)
            new_execution_times = deque(self._execution_times, maxlen=value)
            new_error_counts = deque(self._error_counts, maxlen=value)
            new_connection_attempts = deque(self._connection_attempts, maxlen=value)
            new_connection_failures = deque(self._connection_failures, maxlen=value)
            
            # Replace the old deques with the new ones
            self._request_latencies = new_request_latencies
            self._execution_times = new_execution_times
            self._error_counts = new_error_counts
            self._connection_attempts = new_connection_attempts
            self._connection_failures = new_connection_failures
    
    def record_request_latency(self, latency_ms: float) -> None:
        """
        Record the latency of an MCP request.
        
        Args:
            latency_ms: Request latency in milliseconds
        """
        if not self.enabled:
            return
        
        with self._lock:
            self._request_latencies.append((time.time(), latency_ms))
            self._current_period["request_count"] += 1
            self._summary["total_requests"] += 1
            
            # Check for alert threshold
            if latency_ms > self.alert_thresholds["request_latency"]:
                logger.warning(f"High request latency detected: {latency_ms}ms (threshold: {self.alert_thresholds['request_latency']}ms)")
    
    def record_execution_time(self, execution_time_ms: float) -> None:
        """
        Record the execution time of a Lua command.
        
        Args:
            execution_time_ms: Execution time in milliseconds
        """
        if not self.enabled:
            return
        
        with self._lock:
            self._execution_times.append((time.time(), execution_time_ms))
            
            # Check for alert threshold
            if execution_time_ms > self.alert_thresholds["lua_execution_time"]:
                logger.warning(f"Long execution time detected: {execution_time_ms}ms (threshold: {self.alert_thresholds['lua_execution_time']}ms)")
    
    def record_error(self, error_type: str) -> None:
        """
        Record an error event.
        
        Args:
            error_type: Type of error encountered
        """
        if not self.enabled:
            return
        
        with self._lock:
            self._error_counts.append((time.time(), error_type))
            self._current_period["error_count"] += 1
            self._summary["total_errors"] += 1
            
            # Update error rate - if there are no requests yet, use 1 to avoid division by zero
            # but also ensure 100% error rate for errors before any requests
            if self._summary["total_requests"] > 0:
                self._summary["error_rate"] = self._summary["total_errors"] / self._summary["total_requests"]
            else:
                self._summary["error_rate"] = 1.0
            
            # Check for alert threshold
            if self._summary["error_rate"] > self.alert_thresholds["error_rate"]:
                logger.warning(f"High error rate detected: {self._summary['error_rate']:.2%} (threshold: {self.alert_thresholds['error_rate']:.2%})")
    
    def record_connection_attempt(self, successful: bool) -> None:
        """
        Record a connection attempt to the Lua Gadget.
        
        Args:
            successful: Whether the connection attempt was successful
        """
        if not self.enabled:
            return
        
        with self._lock:
            self._connection_attempts.append((time.time(), successful))
            self._current_period["connection_attempt_count"] += 1
            self._summary["total_connection_attempts"] += 1
            
            if not successful:
                self._connection_failures.append(time.time())
                self._current_period["connection_failure_count"] += 1
                self._summary["total_connection_failures"] += 1
                
                # Check for alert threshold on connection failures within reporting interval
                recent_failures = [t for t in self._connection_failures if time.time() - t <= self.reporting_interval]
                if len(recent_failures) >= self.alert_thresholds["connection_failures"]:
                    logger.warning(f"High connection failure rate: {len(recent_failures)} failures in the last {self.reporting_interval} seconds")
    
    def get_metrics_summary(self) -> Dict[str, Any]:
        """
        Get a summary of current metrics.
        
        Returns:
            Dict containing metrics summary
        """
        with self._lock:
            # Calculate current averages
            if self._request_latencies:
                self._summary["avg_request_latency"] = sum(l for _, l in self._request_latencies) / len(self._request_latencies)
            
            if self._execution_times:
                self._summary["avg_execution_time"] = sum(t for _, t in self._execution_times) / len(self._execution_times)
            
            # Create a copy to return
            return {
                "timestamp": time.time(),
                "total_requests": self._summary["total_requests"],
                "total_errors": self._summary["total_errors"],
                "total_connection_attempts": self._summary["total_connection_attempts"],
                "total_connection_failures": self._summary["total_connection_failures"],
                "avg_request_latency_ms": round(self._summary["avg_request_latency"], 2),
                "avg_execution_time_ms": round(self._summary["avg_execution_time"], 2),
                "error_rate": self._summary["error_rate"],
                "current_period": {
                    "start_time": self._current_period["start_time"],
                    "duration_seconds": time.time() - self._current_period["start_time"],
                    "request_count": self._current_period["request_count"],
                    "error_count": self._current_period["error_count"],
                    "connection_attempt_count": self._current_period["connection_attempt_count"],
                    "connection_failure_count": self._current_period["connection_failure_count"],
                }
            }
    
    def reset_period_metrics(self) -> None:
        """Reset the metrics for the current reporting period."""
        with self._lock:
            self._current_period = {
                "start_time": time.time(),
                "request_count": 0,
                "error_count": 0,
                "connection_attempt_count": 0,
                "connection_failure_count": 0,
            }
    
    def export_metrics_json(self) -> str:
        """
        Export metrics as a JSON string.
        
        Returns:
            JSON string containing metrics data
        """
        return json.dumps(self.get_metrics_summary())
    
    def export_metrics_prometheus(self) -> str:
        """
        Export metrics in Prometheus format.
        
        Returns:
            String with metrics in Prometheus format
        """
        summary = self.get_metrics_summary()
        output = []
        
        # Add metrics in Prometheus format
        output.append(f"# HELP aispire_mcp_requests_total Total number of requests processed")
        output.append(f"# TYPE aispire_mcp_requests_total counter")
        output.append(f"aispire_mcp_requests_total {summary['total_requests']}")
        
        output.append(f"# HELP aispire_mcp_errors_total Total number of errors encountered")
        output.append(f"# TYPE aispire_mcp_errors_total counter")
        output.append(f"aispire_mcp_errors_total {summary['total_errors']}")
        
        output.append(f"# HELP aispire_mcp_request_latency_ms Average request latency in milliseconds")
        output.append(f"# TYPE aispire_mcp_request_latency_ms gauge")
        output.append(f"aispire_mcp_request_latency_ms {summary['avg_request_latency_ms']}")
        
        output.append(f"# HELP aispire_mcp_execution_time_ms Average execution time in milliseconds")
        output.append(f"# TYPE aispire_mcp_execution_time_ms gauge")
        output.append(f"aispire_mcp_execution_time_ms {summary['avg_execution_time_ms']}")
        
        output.append(f"# HELP aispire_mcp_error_rate Current error rate")
        output.append(f"# TYPE aispire_mcp_error_rate gauge")
        output.append(f"aispire_mcp_error_rate {summary['error_rate']}")
        
        output.append(f"# HELP aispire_mcp_connection_attempts_total Total connection attempts")
        output.append(f"# TYPE aispire_mcp_connection_attempts_total counter")
        output.append(f"aispire_mcp_connection_attempts_total {summary['total_connection_attempts']}")
        
        output.append(f"# HELP aispire_mcp_connection_failures_total Total connection failures")
        output.append(f"# TYPE aispire_mcp_connection_failures_total counter")
        output.append(f"aispire_mcp_connection_failures_total {summary['total_connection_failures']}")
        
        return "\n".join(output)
    
    def _periodic_report(self) -> None:
        """Periodically log metrics summary and check for alerts."""
        while not self._stop_reporting.is_set():
            time.sleep(self.reporting_interval)
            
            try:
                summary = self.get_metrics_summary()
                
                # Log the metrics summary
                logger.info(f"Metrics summary: "
                           f"Requests: {summary['current_period']['request_count']}, "
                           f"Errors: {summary['current_period']['error_count']}, "
                           f"Avg Latency: {summary['avg_request_latency_ms']}ms, "
                           f"Error Rate: {summary['error_rate']:.2%}")
                
                # Reset period metrics
                self.reset_period_metrics()
                
            except Exception as e:
                logger.error(f"Error in metrics reporting: {str(e)}")
    
    def shutdown(self) -> None:
        """Stop the metrics reporting thread and clean up resources."""
        if self._reporting_thread:
            self._stop_reporting.set()
            if self._reporting_thread.is_alive():
                self._reporting_thread.join(timeout=1.0)


# Create a singleton instance that can be imported and used throughout the application
_metrics_instance = None

def initialize_metrics(config: Dict[str, Any]) -> Metrics:
    """
    Initialize the metrics singleton.
    
    Args:
        config: Configuration dictionary with metrics settings
        
    Returns:
        The initialized Metrics instance
    """
    global _metrics_instance
    if _metrics_instance is None:
        _metrics_instance = Metrics(config)
    return _metrics_instance

def get_metrics() -> Optional[Metrics]:
    """
    Get the metrics singleton instance.
    
    Returns:
        The Metrics instance, or None if not initialized
    """
    return _metrics_instance