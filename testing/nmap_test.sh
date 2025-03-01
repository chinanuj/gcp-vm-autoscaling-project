#!/bin/bash
# Test open port 80 on your instance using nmap

TARGET_IP="34.131.245.101"  # Replace with your instance's public IP

echo "Testing HTTP port (80) accessibility on $TARGET_IP using nmap..."
echo "This will verify if the firewall rules are properly configured."

# Check if nmap is installed
if ! command -v nmap &> /dev/null
then
    echo "nmap is not installed. Installing it now..."
    sudo apt-get update
    sudo apt-get install -y nmap
fi

# Run the port scan
echo "Scanning port 80 on $TARGET_IP..."
nmap -p 80 $TARGET_IP

echo "If port 80 is reported as 'filtered' or 'closed' from an unauthorized IP, the firewall rule is working correctly."