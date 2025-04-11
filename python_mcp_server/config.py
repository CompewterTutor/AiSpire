"""
Configuration module for the AiSpire MCP Server.

This module handles loading configuration from environment variables,
configuration files, and provides default values.
"""

import json
import os
from typing import Dict, Any, Optional


def load_config(config_path: Optional[str] = None) -> Dict[str, Any]:
    """
    Load configuration from various sources in the following order:
    1. Default configuration
    2. Configuration file (if provided)
    3. Environment variables
    
    Args:
        config_path: Optional path to a JSON configuration file
        
    Returns:
        Dict containing the merged configuration
    """
    # Default configuration
    config = {
        "lua_gadget": {
            "host": "127.0.0.1",
            "port": 9876,
            "auth_token": "a8f5f167f44f4964e6c998dee827110c",
            "connection_timeout": 5.0,
            "reconnect_attempts": 3,
            "reconnect_delay": 2.0,
        },
        "mcp_server": {
            "host": "127.0.0.1",
            "port": 8765,
            "allowed_origins": ["http://localhost:3000"],
            "auth_required": True,
            "auth_token": "a8f5f167f44f4964e6c998dee827110c",
        },
        "logging": {
            "level": "INFO",
            "file": None,
        },
        "metrics": {
            "enabled": True,
            "history_size": 1000,
            "reporting_interval": 60,  # seconds
            "alert_thresholds": {
                "request_latency": 1000,  # ms
                "lua_execution_time": 5000,  # ms
                "error_rate": 0.05,  # 5%
                "connection_failures": 5  # count within reporting interval
            },
            "expose_prometheus": True,
            "prometheus_port": 9090
        }
    }
    
    # Load configuration from file if provided
    if config_path and os.path.exists(config_path):
        try:
            with open(config_path, 'r') as f:
                file_config = json.load(f)
                # Deep merge the configurations
                deep_merge(config, file_config)
        except Exception as e:
            print(f"Error loading configuration file: {e}")
    
    # Override with environment variables
    # LUA_GADGET
    if os.environ.get("AISPIRE_LUA_HOST"):
        config["lua_gadget"]["host"] = os.environ.get("AISPIRE_LUA_HOST")
    
    if os.environ.get("AISPIRE_LUA_PORT"):
        try:
            config["lua_gadget"]["port"] = int(os.environ.get("AISPIRE_LUA_PORT"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_LUA_AUTH_TOKEN"):
        config["lua_gadget"]["auth_token"] = os.environ.get("AISPIRE_LUA_AUTH_TOKEN")
    
    if os.environ.get("AISPIRE_LUA_TIMEOUT"):
        try:
            config["lua_gadget"]["connection_timeout"] = float(os.environ.get("AISPIRE_LUA_TIMEOUT"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_LUA_RECONNECT_ATTEMPTS"):
        try:
            config["lua_gadget"]["reconnect_attempts"] = int(os.environ.get("AISPIRE_LUA_RECONNECT_ATTEMPTS"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_LUA_RECONNECT_DELAY"):
        try:
            config["lua_gadget"]["reconnect_delay"] = float(os.environ.get("AISPIRE_LUA_RECONNECT_DELAY"))
        except ValueError:
            pass
    
    # MCP_SERVER
    if os.environ.get("AISPIRE_MCP_HOST"):
        config["mcp_server"]["host"] = os.environ.get("AISPIRE_MCP_HOST")
    
    if os.environ.get("AISPIRE_MCP_PORT"):
        try:
            config["mcp_server"]["port"] = int(os.environ.get("AISPIRE_MCP_PORT"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_MCP_AUTH_REQUIRED"):
        config["mcp_server"]["auth_required"] = os.environ.get("AISPIRE_MCP_AUTH_REQUIRED").lower() == "true"
    
    if os.environ.get("AISPIRE_MCP_AUTH_TOKEN"):
        config["mcp_server"]["auth_token"] = os.environ.get("AISPIRE_MCP_AUTH_TOKEN")
    
    if os.environ.get("AISPIRE_MCP_ALLOWED_ORIGINS"):
        try:
            origins = os.environ.get("AISPIRE_MCP_ALLOWED_ORIGINS", "").split(",")
            config["mcp_server"]["allowed_origins"] = [origin.strip() for origin in origins if origin.strip()]
        except Exception:
            pass
    
    # LOGGING
    if os.environ.get("AISPIRE_LOG_LEVEL"):
        config["logging"]["level"] = os.environ.get("AISPIRE_LOG_LEVEL")
    
    if os.environ.get("AISPIRE_LOG_FILE"):
        config["logging"]["file"] = os.environ.get("AISPIRE_LOG_FILE")
    
    # METRICS
    if os.environ.get("AISPIRE_METRICS_ENABLED"):
        config["metrics"]["enabled"] = os.environ.get("AISPIRE_METRICS_ENABLED").lower() == "true"
    
    if os.environ.get("AISPIRE_METRICS_HISTORY_SIZE"):
        try:
            config["metrics"]["history_size"] = int(os.environ.get("AISPIRE_METRICS_HISTORY_SIZE"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_METRICS_REPORTING_INTERVAL"):
        try:
            config["metrics"]["reporting_interval"] = int(os.environ.get("AISPIRE_METRICS_REPORTING_INTERVAL"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_METRICS_EXPOSE_PROMETHEUS"):
        config["metrics"]["expose_prometheus"] = os.environ.get("AISPIRE_METRICS_EXPOSE_PROMETHEUS").lower() == "true"
    
    if os.environ.get("AISPIRE_METRICS_PROMETHEUS_PORT"):
        try:
            config["metrics"]["prometheus_port"] = int(os.environ.get("AISPIRE_METRICS_PROMETHEUS_PORT"))
        except ValueError:
            pass
    
    # Alert thresholds
    if os.environ.get("AISPIRE_METRICS_ALERT_LATENCY"):
        try:
            config["metrics"]["alert_thresholds"]["request_latency"] = float(os.environ.get("AISPIRE_METRICS_ALERT_LATENCY"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_METRICS_ALERT_EXECUTION_TIME"):
        try:
            config["metrics"]["alert_thresholds"]["lua_execution_time"] = float(os.environ.get("AISPIRE_METRICS_ALERT_EXECUTION_TIME"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_METRICS_ALERT_ERROR_RATE"):
        try:
            config["metrics"]["alert_thresholds"]["error_rate"] = float(os.environ.get("AISPIRE_METRICS_ALERT_ERROR_RATE"))
        except ValueError:
            pass
    
    if os.environ.get("AISPIRE_METRICS_ALERT_CONNECTION_FAILURES"):
        try:
            config["metrics"]["alert_thresholds"]["connection_failures"] = int(os.environ.get("AISPIRE_METRICS_ALERT_CONNECTION_FAILURES"))
        except ValueError:
            pass
    
    return config


def deep_merge(dest: Dict[str, Any], src: Dict[str, Any]) -> None:
    """
    Deep merge two dictionaries. The source dictionary values overwrite
    the destination dictionary values when there is a conflict.
    
    Args:
        dest: Destination dictionary that will be modified in-place
        src: Source dictionary whose values will override dest
    """
    for key, value in src.items():
        if key in dest and isinstance(dest[key], dict) and isinstance(value, dict):
            deep_merge(dest[key], value)
        else:
            dest[key] = value


def create_default_config_file(path: str) -> bool:
    """
    Create a default configuration file at the specified path.
    
    Args:
        path: Path to save the configuration file
        
    Returns:
        True if the file was created successfully, False otherwise
    """
    try:
        config = {
            "lua_gadget": {
                "host": "127.0.0.1",
                "port": 9876,
                "auth_token": "change_this_to_a_secure_token",
                "connection_timeout": 5.0,
                "reconnect_attempts": 3,
                "reconnect_delay": 2.0,
            },
            "mcp_server": {
                "host": "127.0.0.1",
                "port": 8765,
                "allowed_origins": ["http://localhost:3000"],
                "auth_required": True,
                "auth_token": "change_this_to_a_secure_token",
            },
            "logging": {
                "level": "INFO",
                "file": "aispire_mcp.log",
            },
            "metrics": {
                "enabled": True,
                "history_size": 1000,
                "reporting_interval": 60,
                "alert_thresholds": {
                    "request_latency": 1000,
                    "lua_execution_time": 5000,
                    "error_rate": 0.05,
                    "connection_failures": 5
                },
                "expose_prometheus": True,
                "prometheus_port": 9090
            }
        }
        
        with open(path, 'w') as f:
            json.dump(config, f, indent=2)
        
        return True
    except Exception:
        return False


if __name__ == "__main__":
    # If run directly, create a default config file
    success = create_default_config_file("config.json")
    if success:
        print("Default configuration file created at config.json")
    else:
        print("Failed to create default configuration file")