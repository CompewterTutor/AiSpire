#!/usr/bin/env python3
"""
Runner script for the AiSpire Official MCP Server.

This script provides a command-line interface for starting and configuring the server.
"""

import argparse
import asyncio
import logging
import os
import sys
from pathlib import Path

# Add parent directory to path to import from the project
parent_dir = str(Path(__file__).parent.parent)
if parent_dir not in sys.path:
    sys.path.append(parent_dir)

from server import AiSpireMCPServer

# Configure logging
logger = logging.getLogger()
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)
logger.setLevel(logging.INFO)


def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description="AiSpire Official MCP Server")
    parser.add_argument(
        "--config", "-c", 
        help="Path to configuration file"
    )
    parser.add_argument(
        "--host", 
        help="Hostname to bind the server"
    )
    parser.add_argument(
        "--port", type=int, 
        help="Port to bind the server"
    )
    parser.add_argument(
        "--lua-host", 
        help="Hostname of the Lua socket server"
    )
    parser.add_argument(
        "--lua-port", type=int, 
        help="Port of the Lua socket server"
    )
    parser.add_argument(
        "--log-level", 
        choices=["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"],
        help="Log level"
    )
    parser.add_argument(
        "--test-mode", 
        action="store_true",
        help="Run in test mode with minimal configuration"
    )
    return parser.parse_args()


async def main():
    """Main entry point for the server."""
    args = parse_args()
    
    # Set up environment variables based on command line arguments
    if args.host:
        os.environ["AISPIRE_MCP_HOST"] = args.host
    if args.port:
        os.environ["AISPIRE_MCP_PORT"] = str(args.port)
    if args.lua_host:
        os.environ["AISPIRE_LUA_HOST"] = args.lua_host
    if args.lua_port:
        os.environ["AISPIRE_LUA_PORT"] = str(args.lua_port)
    if args.log_level:
        os.environ["AISPIRE_LOG_LEVEL"] = args.log_level
        logger.setLevel(getattr(logging, args.log_level))
    
    # Set up test mode if requested
    if args.test_mode:
        logger.info("Running in test mode")
        os.environ["AISPIRE_MCP_PORT"] = "8766"  # Use different port for testing
    
    # Start the server
    config_path = args.config
    server = AiSpireMCPServer(config_path)
    
    try:
        await server.start()
    except asyncio.CancelledError:
        logger.info("Server shutdown requested")
    except Exception as e:
        logger.error(f"Server error: {str(e)}")
    finally:
        await server.stop()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Server stopped by user")