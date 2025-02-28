# GCP VM Auto-scaling and Security Implementation Report

## Introduction

This report documents the step-by-step process of creating a virtual machine in Google Cloud Platform (GCP), implementing auto-scaling policies based on workload, and configuring security measures like firewall rules and Identity and Access Management (IAM).

## Objectives

1. Create a VM instance on GCP
2. Configure auto-scaling policies based on CPU utilization
3. Implement security measures including IAM roles and firewall rules
4. Test and verify auto-scaling functionality

## Implementation Steps

### 1. Setting Up GCP Environment

I began by creating a new GCP project specifically for this assignment. After enabling the necessary APIs, I installed the Google Cloud SDK to facilitate command-line interactions with GCP.

### 2. Creating a VM Instance

I created a base VM instance with the following specifications:
- Name: base-instance
- Machine type: e2-medium (2 vCPU, 4GB memory)
- Boot disk: Ubuntu 20.04 LTS
- Region/Zone: us-central1-a
- Network: default VPC with HTTP and HTTPS traffic allowed

After creation, I installed the necessary software including nginx for serving web content and the stress utility for testing CPU load.

### 3. Creating an Instance Template

To enable auto-scaling, I created an instance template based on the configuration of the base VM. The template includes a startup script that installs nginx and the stress utility, and creates a custom index.html file displaying the hostname of each instance.

### 4. Configuring a Managed Instance Group (MIG)

I set up a regional managed instance group with the following auto-scaling configuration:
- Minimum instances: 1
- Maximum instances: 3
- Scaling metric: CPU utilization
- Target CPU utilization: 70%
- Cool-down period: 60 seconds

I also configured a health check to ensure that only healthy instances remain in the group.

### 5. Implementing Security Measures

#### IAM Roles
I created a custom service account with limited permissions following the principle of least privilege. The service account has only the necessary roles:
- Compute Instance Admin (v1)
- Compute Network User

#### Firewall Rules
I implemented three key firewall rules:
1. allow-ssh: Permits SSH access only from my IP address
2. allow-web: Allows HTTP/HTTPS traffic from any source
3. deny-all-ingress: Denies all other incoming traffic (with lower priority)

### 6. Testing Auto-scaling

To test the auto-scaling configuration, I ran a script that generates high CPU load using the stress utility. Within approximately 90 seconds, the managed instance group began creating a new instance. When the load test completed, the additional instance was automatically terminated after the CPU utilization returned to normal levels.

## Conclusion

This implementation demonstrates a secure, scalable VM setup in GCP that automatically adjusts to varying workloads. By combining auto-scaling based on CPU utilization with robust security measures, I've created an efficient, protected cloud environment that can handle fluctuating demands while maintaining security best practices.

The architecture provides several benefits:
- Cost efficiency by only running additional instances when needed
- High availability through the regional deployment
- Security through restricted access and least privilege principles

All configuration files and scripts used in this implementation are available in the repository for review and replication.