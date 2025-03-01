#!/bin/bash
# Create an instance template for auto-scaling

PROJECT_ID="your-project-id"
TEMPLATE_NAME="assignment-2-template"
MACHINE_TYPE="e2-medium"
IMAGE_FAMILY="ubuntu-2004-lts"
IMAGE_PROJECT="ubuntu-os-cloud"

gcloud config set project $PROJECT_ID

gcloud compute instance-templates create $TEMPLATE_NAME \
  --machine-type=$MACHINE_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --tags=http-server,https-server \
  --metadata=startup-script='#!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2'

echo "Instance template $TEMPLATE_NAME created successfully."