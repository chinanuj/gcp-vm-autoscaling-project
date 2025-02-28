#!/bin/bash
# GCP VM and Auto-scaling Setup Script

# Exit on any error
set -e

# Variables (adjust as needed)
PROJECT_ID="vm-autoscale-assignment"
REGION="us-central1"
ZONE="us-central1-a"
VM_NAME="base-instance"
MACHINE_TYPE="e2-medium"
TEMPLATE_NAME="autoscale-template"
MIG_NAME="autoscaling-group"

# Ensure the project exists
echo "Setting up project..."
gcloud projects describe $PROJECT_ID || gcloud projects create $PROJECT_ID

# Set as default project
gcloud config set project $PROJECT_ID

# Enable required APIs
echo "Enabling APIs..."
gcloud services enable compute.googleapis.com

# Create VM instance
echo "Creating VM instance..."
gcloud compute instances create $VM_NAME \
  --project=$PROJECT_ID \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --network-interface=network=default,subnet=default \
  --metadata=startup-script-url=gs://bucket-name/startup-script.sh \
  --tags=http-server,https-server \
  --create-disk=auto-delete=yes,boot=yes,device-name=$VM_NAME,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230213,mode=rw,size=10,type=pd-balanced \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring

# Create instance template
echo "Creating instance template..."
gcloud compute instance-templates create $TEMPLATE_NAME \
  --project=$PROJECT_ID \
  --machine-type=$MACHINE_TYPE \
  --network-interface=network=default,subnet=default \
  --metadata=startup-script-url=gs://bucket-name/startup-script.sh \
  --tags=http-server,https-server \
  --create-disk=auto-delete=yes,boot=yes,device-name=template-disk,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230213,mode=rw,size=10,type=pd-balanced \
  --shielded-secure-boot \
  --shielded-vtpm \
  --shielded-integrity-monitoring

# Create health check
echo "Creating health check..."
gcloud compute health-checks create http http-health-check \
  --project=$PROJECT_ID \
  --port=80 \
  --request-path=/ \
  --check-interval=30s \
  --timeout=5s \
  --healthy-threshold=2 \
  --unhealthy-threshold=3

# Create managed instance group
echo "Creating managed instance group..."
gcloud compute instance-groups managed create $MIG_NAME \
  --project=$PROJECT_ID \
  --base-instance-name=$MIG_NAME \
  --template=$TEMPLATE_NAME \
  --size=1 \
  --region=$REGION \
  --health-check=http-health-check \
  --initial-delay=120

# Configure autoscaling
echo "Configuring autoscaling..."
gcloud compute instance-groups managed set-autoscaling $MIG_NAME \
  --project=$PROJECT_ID \
  --region=$REGION \
  --min-num-replicas=1 \
  --max-num-replicas=3 \
  --target-cpu-utilization=0.7 \
  --cool-down-period=60

# Create firewall rules
echo "Creating firewall rules..."
# Allow SSH from your IP only (replace YOUR_IP_ADDRESS with your actual IP)
gcloud compute firewall-rules create allow-ssh \
  --project=$PROJECT_ID \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:22 \
  --source-ranges=YOUR_IP_ADDRESS/32

# Allow HTTP/HTTPS
gcloud compute firewall-rules create allow-web \
  --project=$PROJECT_ID \
  --direction=INGRESS \
  --priority=1100 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:80,tcp:443 \
  --source-ranges=0.0.0.0/0

# Deny all other incoming traffic
gcloud compute firewall-rules create deny-all-ingress \
  --project=$PROJECT_ID \
  --direction=INGRESS \
  --priority=2000 \
  --network=default \
  --action=DENY \
  --rules=all \
  --source-ranges=0.0.0.0/0

echo "Setup completed successfully!"