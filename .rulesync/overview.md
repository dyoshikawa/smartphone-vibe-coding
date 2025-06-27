---
root: true
targets: ["*"]
description: "Project overview and general development guidelines"
globs: ["*"]
---

# Smartphone Vibe Coding Project

This project provides Infrastructure-as-Code (IaC) to enable mobile-friendly remote coding sessions through cloud instances. It creates a cost-effective environment for running Claude Code on cloud platforms, accessible from smartphones via SSH.

## Project Type
- Infrastructure automation project
- Cloud-based development environment
- Mobile-first coding solution

## Technology Stack
- **Infrastructure**: Terraform (HCL)
- **Cloud Provider**: Google Cloud Platform (planned: AWS)
- **Runtime**: Cloud Functions (Python 3.9), Compute Engine (Ubuntu 22.04 LTS)
- **Mobile Access**: Termius SSH client

## Architecture
- On-demand compute instances with automatic cost optimization
- HTTP-triggered functions for instance management
- Scheduled automatic shutdown (midnight JST)
- Static IP for consistent mobile access

## Development Principles
1. **Cost Optimization**: Use free tier resources where possible, implement automatic shutdown
2. **Mobile-First**: Design for easy access from smartphones
3. **Security**: SSH key-based authentication, consider adding HTTP endpoint authentication
4. **Simplicity**: Keep infrastructure minimal and maintainable

## Key Considerations
- All infrastructure changes should be tested in a dev environment first
- Document all Terraform variables clearly
- Keep sensitive data in terraform.tfvars (gitignored)
- Provide both English and Japanese documentation
