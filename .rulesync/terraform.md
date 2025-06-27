---
root: false
targets: ["*"]
description: "Terraform and Infrastructure as Code guidelines"
globs: ["**/*.tf", "**/*.tfvars", "**/*.hcl"]
---

# Terraform Development Guidelines

## Code Style
- Use consistent indentation (2 spaces)
- Group related resources together
- Use meaningful resource names that describe their purpose
- Always use explicit dependencies when needed

## Variable Management
- Define all variables with descriptions
- Set appropriate defaults where sensible
- Use validation blocks for critical variables
- Document variable requirements in README files

## Resource Naming
- Use kebab-case for resource names
- Prefix resources with their type (e.g., `managed-instance`, `start-function`)
- Include purpose in the name

## Best Practices
1. **State Management**: Always use remote state for production
2. **Versioning**: Pin provider versions explicitly
3. **Modules**: Consider extracting reusable components into modules
4. **Outputs**: Export all important values (IPs, URLs, IDs)
5. **Security**: Never commit sensitive values, use variables

## Testing
- Run `terraform fmt` before committing
- Validate with `terraform validate`
- Plan changes with `terraform plan` before applying
- Test in a separate environment first

## Documentation
- Document all non-obvious configurations
- Provide examples in terraform.tfvars.example
- Update README when adding new variables or resources