#!/bin/bash
# Create a single VM instance on GCP with Apache installed

# Set your project ID and zone
PROJECT_ID="your-project-id"
ZONE="us-central1-a"
INSTANCE_NAME="assignment-2-gcp-vm"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="ubuntu-2004-lts"
IMAGE_PROJECT="ubuntu-os-cloud"

# Set the active project
gcloud config set project $PROJECT_ID

# Create the VM instance with HTTP and HTTPS tags
gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --tags=http-server,https-server \
  --metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2'

echo "VM instance $INSTANCE_NAME created with Apache installed."