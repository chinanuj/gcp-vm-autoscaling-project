# GCP VM Auto-Scaling & Security Configuration

## Overview

This repository contains all the necessary scripts, configuration files, and documentation for the assignment on setting up a Google Cloud Platform (GCP) Virtual Machine (VM), implementing auto-scaling policies based on workload, and configuring security measures such as firewall rules and IAM roles.

It includes:
- Scripts to create a VM instance.
- Scripts to create an instance template and Managed Instance Group (MIG) with auto-scaling.
- Scripts to configure custom firewall rules that restrict access to a specified IP (e.g., 223.238.204.234/32).
- Scripts to set up IAM roles for restricted access.
- Testing scripts to verify auto-scaling and firewall rule effectiveness (using tools like nmap, curl, and online resources such as Ping.eu and WhatIsMyIP.com).
- A Terraform configuration (optional) for those who prefer Infrastructure-as-Code.
- An architecture diagram and a detailed PDF report.

## Repository Structure

assignment-2-gcp/ ├── README.md # This file ├── report.pdf # Detailed project report ├── diagrams/ │ └── architecture_diagram.png # Architecture diagram of the setup ├── scripts/ │ ├── create_vm.sh # Create a single VM instance │ ├── create_instance_template.sh # Create an instance template │ ├── create_mig.sh # Create a Managed Instance Group with auto-scaling │ ├── setup_firewall.sh # Configure custom firewall rules │ ├── setup_iam.sh # Set up IAM roles │ └── stress_test.sh # Simulate CPU load for testing auto-scaling ├── testing/ │ ├── nmap_test.sh # Test open port using nmap │ └── curl_test.sh # Test HTTP response using curl └── terraform/ # Optional Terraform configuration ├── main.tf ├── variables.tf └── outputs.tf

markdown
Copy
Edit

## Prerequisites

- A GCP account with billing enabled.
- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install) installed and configured.
- (For local testing) A Unix-based terminal (macOS or Linux) or Windows with a compatible shell.
- Optional: [Terraform](https://www.terraform.io/) if you prefer to use Terraform for deployment.

## Setup Instructions

### 1. Create and Configure a VM Instance
- **Create a Single VM:**
  ```bash
  chmod +x scripts/create_vm.sh
  ./scripts/create_vm.sh
This script uses gcloud to create a VM instance with Apache installed.

2. Configure Auto-Scaling
Create an Instance Template:
bash
Copy
Edit
chmod +x scripts/create_instance_template.sh
./scripts/create_instance_template.sh
Create a Managed Instance Group (MIG) with Auto-Scaling:
bash
Copy
Edit
chmod +x scripts/create_mig.sh
./scripts/create_mig.sh
3. Configure Security Measures
Firewall Rules
Set Up Custom Firewall Rules:
bash
Copy
Edit
chmod +x scripts/setup_firewall.sh
./scripts/setup_firewall.sh
This script sets firewall rules to allow HTTP/HTTPS traffic only from the IP 223.238.204.234/32.
IAM Roles
Configure IAM Roles:
bash
Copy
Edit
chmod +x scripts/setup_iam.sh
./scripts/setup_iam.sh
Modify the script to include the appropriate email and role as needed.
4. Testing
Auto-Scaling and Load Testing
Stress Test on a VM Instance: Log into your instance via SSH and run:
bash
Copy
Edit
chmod +x scripts/stress_test.sh
./scripts/stress_test.sh
This script installs and runs the stress tool to simulate CPU load.
Firewall Rule Testing
Allowed Source Test (from your allowed IP): If your public IP is 223.238.204.234, test with:
bash
Copy
Edit
chmod +x testing/curl_test.sh
./testing/curl_test.sh
Disallowed Source Test: Use a VPN or an online port checker such as Ping.eu to verify that port 80 is blocked for IPs other than the allowed one.
Port Scan Test: Run:
bash
Copy
Edit
chmod +x testing/nmap_test.sh
./testing/nmap_test.sh
This uses nmap to check that port 80 is closed or filtered when accessed from a disallowed source.
5. (Optional) Terraform Deployment
If you prefer using Terraform:

Initialize Terraform:
bash
Copy
Edit
cd terraform
terraform init
Deploy the Infrastructure:
bash
Copy
Edit
terraform apply
Confirm the changes when prompted.
6. Documentation
PDF Report:
The detailed project report is included as report.pdf. It covers the design, implementation, testing procedures, and results.
Architecture Diagram:
See the diagrams/architecture_diagram.png for a visual overview of the setup.
Conclusion
This repository includes all required code files, testing scripts, configuration files, and documentation to implement auto-scaling and security measures on GCP. Follow the scripts step-by-step and refer to the report for detailed explanations and test outcomes.