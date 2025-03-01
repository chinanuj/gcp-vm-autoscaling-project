# GCP VM Auto-Scaling & Security Configuration

## Overview

This repository provides a complete, end-to-end solution for setting up a Google Cloud Platform (GCP) Virtual Machine (VM) with auto-scaling policies based on workload and robust security measures (firewall rules and IAM roles). It includes scripts, configuration files, and detailed testing procedures using tools such as `curl`, `nmap`, and `stress`, along with instructions for online testing via Ping.eu and WhatIsMyIP.com.

The repository contains:
- Scripts to create a VM instance with Apache installed.
- Scripts to create an instance template and Managed Instance Group (MIG) for auto-scaling.
- Scripts to configure custom firewall rules (allowing only a specific IP, e.g., `223.238.204.234/32`).
- Scripts to set up IAM roles for restricted access.
- Testing scripts to verify auto-scaling and firewall rule effectiveness.
- Optional Terraform configuration for Infrastructure-as-Code deployment.
- An architecture diagram and a detailed PDF project report.

## Repository Structure

```
assignment-2-gcp/
├── README.md                  # This file (complete documentation)
├── report.pdf                 # Detailed project report (design, implementation, testing)
├── scripts/
│   ├── create_vm.sh             # Create a single VM instance with Apache installed
│   ├── create_instance_template.sh  # Create an instance template for auto-scaling
│   ├── create_mig.sh            # Create a Managed Instance Group (MIG) with auto-scaling
│   ├── setup_firewall.sh        # Configure custom firewall rules
│   ├── setup_iam.sh             # Set up IAM roles for restricted access
│   └── stress_test.sh           # Simulate CPU load for testing auto-scaling
├── testing/
│   ├── nmap_test.sh             # Test port access using nmap
│   └── curl_test.sh             # Test HTTP response using curl
├── config/
│   ├── firewall-rules.yaml      # Deployment Manager config for custom firewall rules
│   └── iam-role.yaml            # Deployment Manager config for IAM policy bindings
└── terraform/                   # Optional Terraform configuration
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Prerequisites

- A GCP account with billing enabled.
- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install) installed and configured.
- A Unix-based terminal (macOS/Linux) or Windows (with a compatible shell).
- Optional: [Terraform](https://www.terraform.io/) if you prefer using Infrastructure-as-Code.
- Basic knowledge of command-line tools such as `curl`, `nmap`, `ssh`, and `ping`.

## Setup and Deployment Instructions

### 1. Create and Configure a VM Instance

#### Using the `scripts/create_vm.sh` Script:
1. **Edit the Script:**  
   Replace `your-project-id` with your actual GCP project ID.
2. **Make It Executable and Run:**
   ```bash
   chmod +x scripts/create_vm.sh
   ./scripts/create_vm.sh
   ```

This script creates a VM instance (named assignment-2-gcp-vm) in the specified zone with the Apache web server installed (which listens on port 80).

**Manual Verification:**
- **SSH into the Instance:**
  From the GCP Console, click the "SSH" button next to your VM.
- **Check Apache Status:**
  Run:
  ```bash
  sudo systemctl status apache2
  ```
  You should see Apache running.

### 2. Configure Auto-Scaling

**Create an Instance Template with scripts/create_instance_template.sh:**
1. **Edit the Script:**
   Replace `your-project-id` with your actual project details.
2. **Run the Script:**
   ```bash
   chmod +x scripts/create_instance_template.sh
   ./scripts/create_instance_template.sh
   ```

**Create a Managed Instance Group (MIG) with scripts/create_mig.sh:**
1. **Edit the Script:**
   Adjust any necessary parameters.
2. **Run the Script:**
   ```bash
   chmod +x scripts/create_mig.sh
   ./scripts/create_mig.sh
   ```

The script creates a MIG using the instance template and configures auto-scaling with the following parameters:
- Target CPU Utilization: 60%
- Min Instances: 1
- Max Instances: 5
- Cooldown Period: 60 seconds

### 3. Configure Security Measures

**Firewall Rules via scripts/setup_firewall.sh:**
1. **Edit the Script:**
   Set the ALLOWED_IP variable to your allowed IP (e.g., 223.238.204.234/32).
2. **Run the Script:**
   ```bash
   chmod +x scripts/setup_firewall.sh
   ./scripts/setup_firewall.sh
   ```

This configures firewall rules to allow only HTTP (port 80) and HTTPS (port 443) traffic from the specified IP.

**IAM Roles via scripts/setup_iam.sh:**
1. **Edit the Script:**
   Replace `your-project-id` and `user@example.com` with your project ID and the appropriate user email.
2. **Run the Script:**
   ```bash
   chmod +x scripts/setup_iam.sh
   ./scripts/setup_iam.sh
   ```

This assigns the Compute Viewer role (or any additional roles) to the specified user.

### 4. Testing Procedures

**Auto-Scaling and Load Testing:**
- **Stress Test:**
  SSH into your VM (or a MIG instance) and run:
  ```bash
  chmod +x scripts/stress_test.sh
  ./scripts/stress_test.sh
  ```
  This script installs the stress tool (if not already installed) and simulates CPU load (using 2 CPU cores for 300 seconds) to trigger auto-scaling.

**Firewall Rule Testing:**
- **Allowed Source Test (from your allowed IP):**

  1. **Web Browser:**
     Navigate to:
     ```
     http://34.131.245.101:80
     ```
     (Replace 34.131.245.101 with your instance's public IP.) You should see the Apache default page.
  
  2. **Using Curl:**
     Run:
     ```bash
     chmod +x testing/curl_test.sh
     ./testing/curl_test.sh
     ```
     You should see a successful HTTP response.

- **Disallowed Source Test:** To simulate access from a disallowed IP (i.e., not 223.238.204.234):

  1. **Use a VPN or Proxy:**
     Connect via a VPN that assigns you a different public IP.
  
  2. **Online Testing:**
     Visit [Ping.eu Port Check](https://ping.eu/port-chk/), enter your instance's IP and port 80, and verify that the port is reported as closed or filtered.
  
  3. **Using Nmap:**
     Run:
     ```bash
     chmod +x testing/nmap_test.sh
     ./testing/nmap_test.sh
     ```
     The output should show that port 80 is closed or filtered when accessed from a disallowed source.

**Additional Testing:**

1. **Ping:**
   Use the ping command (e.g., `ping 34.131.245.101`) to check basic connectivity. (Note: Ping may succeed even if the firewall blocks application-specific ports.)

2. **WhatIsMyIP.com:**
   Visit [WhatIsMyIP.com](https://www.whatismyip.com/) to verify your current public IP and ensure it matches your allowed IP during testing.

### 5. (Optional) Terraform Deployment

If you prefer to deploy using Terraform:

1. **Navigate to the Terraform Directory:**
   ```bash
   cd terraform
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Apply the Configuration:**
   ```bash
   terraform apply
   ```
   Confirm the changes when prompted. This deploys an instance template and a region-based Managed Instance Group with auto-scaling settings.


## Conclusion

This repository delivers a professional, complete implementation of GCP auto-scaling and security measures. It covers:

1. Automated VM creation and Apache installation.
2. Auto-scaling configuration with Managed Instance Groups.
3. Firewall and IAM setup to restrict access.
4. Comprehensive testing using curl, nmap, stress, and online tools.
5. Optional Terraform configuration for Infrastructure-as-Code.
6. Detailed documentation and a final project report.
