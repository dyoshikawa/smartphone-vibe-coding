# Smartphone Vibe Coding

A repository for enabling "Vibe Coding" from smartphones by setting up Claude Code on cloud instances and connecting via SSH from mobile devices.

## Overview

This project provides infrastructure-as-code to deploy a cost-effective cloud environment for remote coding sessions. It creates managed compute instances on Google Cloud Platform that can be easily started/stopped on demand, helping minimize costs while providing a powerful coding environment accessible from mobile devices.

Key features:
- Monthly subscription-based Claude Code (not API key-based pricing)
- On-demand instance management to minimize compute costs
- Automatic daily shutdown at midnight (JST)
- Static IP address for consistent access
- Mobile-friendly access via [Termius](https://termius.com/) SSH client

## Architecture

The infrastructure includes:
- **Compute Instance**: Ubuntu 22.04 LTS on e2-micro (free tier eligible)
- **Cloud Functions**: HTTP-triggered functions for starting/stopping instances
- **Cloud Scheduler**: Automatic daily shutdown at midnight JST
- **Static IP**: Persistent IP address for SSH access

## Prerequisites

- Terraform (version requirement to be specified)
- Google Cloud Platform account with billing enabled
- gcloud CLI configured with appropriate permissions
- Claude Code subscription
- Termius app on iOS/Android device

## Quick Start

1. Clone this repository
2. Navigate to the `googlecloud` directory
   - For detailed Google Cloud setup instructions, see [googlecloud/README.md](googlecloud/README.md)
3. Configure Terraform variables in `terraform.tfvars`:
   ```hcl
   project_id     = "your-gcp-project-id"
   project_number = "your-gcp-project-number"
   ```
4. Deploy the infrastructure:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
5. After deployment, Terraform will output:
   - Instance start URL
   - Instance stop URL
   - Static IP address

## Usage

### Starting the Instance
- Via HTTP: Access the start URL provided by Terraform output
- Via CLI: `gcloud compute instances start managed-instance --zone=asia-northeast1-a`

### Stopping the Instance
- Via HTTP: Access the stop URL provided by Terraform output
- Via CLI: `gcloud compute instances stop managed-instance --zone=asia-northeast1-a`
- Automatic: Instance stops daily at midnight JST

### Connecting from Mobile
1. Install Termius on your mobile device
2. Create a new host with the static IP address
3. Configure SSH keys for authentication
4. Connect and start coding!

## Setting up the Development Environment

### Automated Setup (Recommended)

The project includes Ansible playbooks to automatically set up your development environment:

1. After connecting to the instance, clone this repository
2. Navigate to the `ansible` directory
3. Follow the setup instructions in [ansible/README.md](ansible/README.md)
4. The playbook will automatically install:
   - Git configuration
   - mise, Node.js, and Claude Code
   - GitHub CLI
   - Docker

### Manual Setup

Alternatively, you can manually install Claude Code following the [official documentation](https://docs.anthropic.com/claude-code).

For detailed setup instructions, see [googlecloud/README.md](googlecloud/README.md).

## Cost Optimization

- Uses e2-micro instance (free tier eligible)
- Automatic daily shutdown prevents 24/7 charges
- On-demand start/stop via HTTP endpoints
- Static IP ensures no changes needed in SSH client

## TODO

- [ ] AWS implementation
- [x] Google Cloud implementation

## Security Considerations

- Cloud Functions are publicly accessible (consider adding authentication)
- SSH access should be secured with key-based authentication
- Consider implementing IP allowlisting for additional security

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT
