# Google Cloud Setup Guide

This guide provides step-by-step instructions for setting up a development environment on Google Cloud using Terraform and configuring the server with essential development tools.

## Prerequisites

- Terraform installed on your local machine
- Google Cloud account with appropriate permissions
- Basic knowledge of SSH and command line operations

## Local Machine Setup

### 1. Generate SSH Key

Generate an SSH key pair for secure connection to your cloud instance:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/smartphone_vibe_coding -C "YOUR_EMAIL@example.com"
```

### 2. Configure Terraform VariablesR

Copy the example variables file and configure it with your actual values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values:
- `project_id`: Your Google Cloud project ID
- `project_number`: Your Google Cloud project number
- `ssh_keys`: SSH public key in the format "username:ssh-rsa AAAAB3..."

### 3. Deploy Infrastructure with Terraform

Initialize and deploy your Google Cloud infrastructure:

```bash
terraform init
terraform plan
terraform apply
```

### 4. Connect to the Server

Once the infrastructure is deployed, connect to your server using SSH:

```bash
ssh -i ~/.ssh/smartphone_vibe_coding YOUR_USERNAME@IP_ADDRESS
```

Replace `YOUR_USERNAME` with your actual username and `IP_ADDRESS` with the public IP of your instance.

## Remote Server Configuration

After connecting to your remote server, follow these steps to set up your development environment.

### 1. Configure Git

Set up your Git configuration with your personal details:

```bash
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
```

### 2. Install Claude Code

Install Claude Code using mise package manager:

```bash
# Install mise
curl https://mise.run | sh
echo "eval \"\$(/home/YOUR_USERNAME/.local/bin/mise activate bash)\"" >> ~/.bashrc
exec $SHELL -l

# Install Node.js and Claude Code
mise use node@24 --global
npm install -g @anthropic-ai/claude-code
```

### 3. Install GitHub CLI

Install the official GitHub CLI for seamless GitHub integration:

```bash
# Add GitHub CLI repository
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install GitHub CLI
sudo apt update -y
sudo apt install gh -y
```

### 4. Authenticate with GitHub

Authenticate GitHub CLI using a Personal Access Token (PAT):

For security, recommended: Use fine-grained personal access token and permit specific repositories.

See: https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

```bash
# Login with PAT.
gh auth login
```

## Additional Resources

- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Google Cloud Documentation](https://cloud.google.com/docs)

## Troubleshooting

If you encounter any issues:

1. Ensure all prerequisites are properly installed
2. Check that your SSH key has the correct permissions: `chmod 600 ~/.ssh/smartphone_vibe_coding`
3. Verify your Google Cloud credentials are properly configured
4. Make sure your firewall rules allow SSH connections on port 22
