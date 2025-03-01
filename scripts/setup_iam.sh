#!/bin/bash
# Set up IAM roles to grant restricted access

PROJECT_ID="your-project-id"
USER_EMAIL="user@example.com"  # Replace with the email of the user

# Grant the Compute Viewer role to the specified user
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="user:$USER_EMAIL" \
  --role="roles/compute.viewer"

echo "IAM role 'Compute Viewer' assigned to $USER_EMAIL"
echo "Note: This role provides read-only access to all compute resources"