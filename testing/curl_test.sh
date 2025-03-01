#!/bin/bash
# Test HTTP response from your instance using curl

TARGET_IP="34.131.245.101"  # Replace with your instance's public IP

echo "Testing HTTP connectivity to $TARGET_IP using curl..."
echo "This will verify if the web server is responding and firewall rules are properly configured."

# Run the curl command with verbose output
echo "Sending HTTP request to http://$TARGET_IP ..."
curl -v http://$TARGET_IP

echo ""
echo "If you received a successful HTTP response, you are accessing from an allowed IP."
echo "If the connection was refused or timed out, either your IP is not in the allowed list or the web server is not running."