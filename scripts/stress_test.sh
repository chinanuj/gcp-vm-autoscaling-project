#!/bin/bash
# Stress test script to simulate CPU load on the VM instance
# This script is intended to be run on the VM (via SSH)

echo "Starting stress test to simulate high CPU load..."
echo "This test will help verify that auto-scaling triggers correctly."

# Install the stress tool if it is not already installed
if ! command -v stress &> /dev/null
then
    echo "Installing stress tool..."
    sudo apt-get update
    sudo apt-get install -y stress
fi

# Run stress test on 2 CPU cores for 300 seconds (5 minutes)
echo "Running stress test on 2 CPU cores for 5 minutes..."
echo "Monitor the GCP Console to observe auto-scaling behavior."
stress --cpu 2 --timeout 300

echo "Stress test completed. Check the GCP Console to verify if auto-scaling was triggered."