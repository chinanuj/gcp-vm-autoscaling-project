#!/bin/bash
# Script to generate CPU load for testing auto-scaling

# Default to 5 minutes if no time specified
DURATION=${1:-300}

echo "Starting CPU stress test for ${DURATION} seconds..."
echo "This should trigger auto-scaling if CPU goes above threshold."
echo "Monitor the GCP Console to see new instances being created."

# Run stress with 8 CPU workers for the specified duration
stress --cpu 8 --timeout ${DURATION}

echo "Stress test completed."
echo "Monitor the GCP Console to see if instances scale back down."