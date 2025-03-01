#!/bin/bash
# Create a Managed Instance Group (MIG) with auto-scaling

PROJECT_ID="your-project-id"
ZONE="us-central1-a"
MIG_NAME="assignment-2-mig"
TEMPLATE_NAME="assignment-2-template"

gcloud config set project $PROJECT_ID

# Create the Managed Instance Group
gcloud compute instance-groups managed create $MIG_NAME \
  --base-instance-name=assignment-2-mig-instance \
  --template=$TEMPLATE_NAME \
  --size=1 \
  --zone=$ZONE

# Configure auto-scaling: target CPU utilization 60%, min 1 instance, max 5 instances, cooldown 60s
gcloud compute instance-groups managed set-autoscaling $MIG_NAME \
  --zone=$ZONE \
  --cool-down-period=60 \
  --max-num-replicas=5 \
  --min-num-replicas=1 \
  --target-cpu-utilization=0.6

echo "Managed Instance Group $MIG_NAME created with auto-scaling configured."
echo "Auto-scaling parameters:"
echo "  - Target CPU utilization: 60%"
echo "  - Min instances: 1"
echo "  - Max instances: 5"
echo "  - Cooldown period: 60 seconds"