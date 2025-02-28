# GCP VM Auto-scaling and Security Implementation

This repository contains all the necessary scripts, configuration files, and documentation for setting up a virtual machine in Google Cloud Platform (GCP) with auto-scaling capabilities and security measures.

## Project Overview

This project demonstrates how to:
- Create a VM instance in GCP
- Configure auto-scaling based on CPU utilization
- Implement security best practices using IAM roles and firewall rules

## Repository Structure

- `/documentation`: Contains the implementation report, architecture diagram, and screenshots
- `/scripts`: Contains shell scripts for setup, VM startup, and load testing
- `/terraform`: Contains Terraform configurations for Infrastructure as Code deployment
- `/config`: Contains YAML configuration files for firewall rules and IAM roles

## Getting Started

1. Clone this repository
2. Follow the step-by-step guide in `documentation/implementation-report.md`
3. Use the provided scripts and configuration files to replicate the setup

## Testing Auto-scaling

1. SSH into your primary VM instance
2. Run the load test script: `./scripts/load-test.sh`
3. Observe the creation of new instances in GCP Console

## Video Demonstration

A video demonstration of this implementation is available [here](link-to-your-video).

## License

This project is licensed under the MIT License - see the LICENSE file for details.