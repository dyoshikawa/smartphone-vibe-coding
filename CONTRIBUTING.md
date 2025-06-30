# Contributing to Smartphone Vibe Coding

Thank you for your interest in contributing to the Smartphone Vibe Coding project! We welcome contributions from the community and are grateful for any help you can provide.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/smartphone-vibe-coding.git
   cd smartphone-vibe-coding
   ```
3. Add the upstream repository as a remote:
   ```bash
   git remote add upstream https://github.com/dyoshikawa/smartphone-vibe-coding.git
   ```

## Development Setup

### Prerequisites

- Terraform
- Google Cloud Platform account with billing enabled
- gcloud CLI configured with appropriate permissions
- Git
- mise (development tool version manager)
- Ansible (for automated server setup)
- SSH key pair for server access

### Tool Version Management with mise

This project uses [mise](https://mise.jdx.dev/) to manage development tool versions. Install mise first, then run:

```bash
mise install
```

This will automatically install the correct versions of:
- Node.js (v24)
- pnpm (v10)

The tool versions are defined in `mise.toml` at the project root.

## Making Changes

1. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following our coding standards:
   - Write clear, self-documenting code
   - Follow the existing code style
   - Keep commits atomic and write meaningful commit messages
   - Add tests for new functionality

3. Install dependencies and test your changes:
   ```bash
   pnpm install
   ```
   - Validate Terraform configurations: `terraform validate`
   - Check Terraform formatting: `terraform fmt -check`
   - Review planned changes: `terraform plan`
   - Test Ansible playbooks: `ansible-playbook --syntax-check playbook.yml`
   - Run security checks: `pnpm run secretlint`

## Submitting a Pull Request

1. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a pull request on GitHub:
   - Provide a clear title and description
   - Reference any related issues
   - Include screenshots for UI changes
   - Ensure all tests pass

3. Wait for review:
   - Address any feedback promptly
   - Make requested changes in new commits
   - Keep the discussion focused and professional

## Code Style Guidelines

- Follow Terraform best practices and conventions
- Follow Ansible best practices for playbook organization
- Follow the existing project structure
- Use meaningful variable and function names
- Keep functions small and focused
- Document complex logic with comments
- Use type annotations where appropriate

## Reporting Issues

- Use the GitHub issue tracker
- Search for existing issues before creating a new one
- Provide clear reproduction steps
- Include relevant system information
- Be respectful and constructive

## Community Guidelines

- Be welcoming and inclusive
- Respect differing viewpoints
- Give and accept constructive feedback gracefully
- Focus on what's best for the community
- Show empathy towards others

## License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

## Questions?

If you have questions about contributing, feel free to:
- Open an issue for discussion
- Ask in the project discussions
- Contact the maintainers

Thank you for contributing to make smartphone coding more accessible!