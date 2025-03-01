#!/bin/bash
# Set up firewall rules to allow HTTP/HTTPS traffic only from a specific IP (223.238.204.234/32)

PROJECT_ID="your-project-id"
ALLOWED_IP="223.238.204.234/32"

gcloud config set project $PROJECT_ID

# Create firewall rule for HTTP traffic
gcloud compute firewall-rules create allow-http-custom \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:80 \
  --source-ranges=$ALLOWED_IP \
  --target-tags=http-server

# Create firewall rule for HTTPS traffic
gcloud compute firewall-rules create allow-https-custom \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:443 \
  --source-ranges=$ALLOWED_IP \
  --target-tags=https-server

echo "Firewall rules created successfully."
echo "HTTP (port 80) and HTTPS (port 443) traffic is now allowed only from IP: $ALLOWED_IP"