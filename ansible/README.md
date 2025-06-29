# Ansible Playbook for Development Environment Setup

This Ansible playbook automates the setup of a development environment on Ubuntu servers, including:

- Git configuration
- mise, Node.js, and Claude Code installation
- GitHub CLI installation
- Docker installation with non-root user configuration
- Tailscale installation

## Prerequisites

- Ansible installed on your local machine
- SSH access to the target Ubuntu server
- Sudo privileges on the target server

## Setup

1. **Update inventory file**

   Edit `inventory.ini` and replace with your actual server details:

   ```ini
   [ubuntu_servers]
   server1 ansible_host=YOUR_SERVER_IP ansible_user=YOUR_USERNAME ansible_ssh_private_key_file=~/.ssh/smartphone_vibe_coding
   ```

2. **Create variables file (optional)**

   Copy the example variables file and configure it with your Git settings:

   ```bash
   cp vars.example.yml vars.yml
   ```

   Edit `vars.yml` with your actual values:

   ```yaml
   git_name: "Your Name"
   git_email: "your.email@example.com"
   
   # Optional: Tailscale auto-configuration
   tailscale_auth_key: "tskey-auth-your-key-here"
   tailscale_advertise_routes: true
   ```

## Usage

### Basic usage (without Git configuration)

```bash
ansible-playbook -i inventory.ini playbook.yml
```

### With Git configuration

```bash
ansible-playbook -i inventory.ini playbook.yml -e "git_name='Your Name'" -e "git_email='your.email@example.com'"
```

### Using variables file

```bash
ansible-playbook -i inventory.ini playbook.yml -e @vars.yml
```

## What the playbook does

### Git Configuration (`tasks/git_config.yml`)
- Sets global Git user name and email
- Configures default branch to `main`
- Sets pull strategy to merge (no rebase)

### Development Tools (`tasks/dev_tools.yml`)
- Installs mise package manager
- Installs Node.js 24 via mise
- Installs Claude Code globally via npm
- Configures shell environment

### GitHub CLI (`tasks/github_cli.yml`)
- Adds GitHub CLI repository
- Installs GitHub CLI
- Ready for `gh auth login` command

### Docker (`tasks/docker.yml`)
- Installs Docker Engine and related packages
- Starts and enables Docker service
- Adds user to docker group (non-root access)
- Verifies installation

### Tailscale (`tasks/tailscale.yml`)
- Adds Tailscale repository and GPG key
- Installs Tailscale
- Starts and enables Tailscale service
- Auto-detects GCE network subnet for route advertisement
- Configures Tailscale for GCE subnet routing (if auth key provided)
- Creates setup script for manual configuration
- Ready for network authentication

## Post-installation steps

After running the playbook, you may need to:

1. **Reload shell environment** to activate mise:
   ```bash
   exec $SHELL -l
   ```

2. **Authenticate with GitHub CLI**:
   ```bash
   gh auth login
   ```

3. **Verify Docker non-root access** (may require logout/login):
   ```bash
   docker run hello-world
   ```

4. **Connect to Tailscale network**:
   
   If you provided an auth key in `vars.yml`, Tailscale should be automatically configured.
   
   Otherwise, authenticate manually:
   ```bash
   sudo tailscale up
   ```
   Follow the authentication link provided.
   
   For GCE subnet routing, run the generated setup script:
   ```bash
   ./setup-tailscale-gce.sh
   ```

5. **Start Claude Code**:
   ```bash
   claude
   ```

## File Structure

```
ansible/
├── README.md
├── playbook.yml          # Main playbook
├── inventory.ini         # Server inventory
├── vars.example.yml      # Example variables file
└── tasks/
    ├── git_config.yml    # Git configuration tasks
    ├── dev_tools.yml     # mise, Node.js, Claude Code
    ├── github_cli.yml    # GitHub CLI installation
    ├── docker.yml        # Docker installation and setup
    └── tailscale.yml     # Tailscale installation
```

Note: `vars.yml` is gitignored and should be created by copying `vars.example.yml`.

## Troubleshooting

- If Docker commands require `sudo`, the user may need to log out and back in for group changes to take effect
- If Claude Code is not found, ensure the shell environment is reloaded to activate mise
- For GitHub CLI authentication issues, refer to the [GitHub CLI documentation](https://cli.github.com/manual/)
- For Tailscale setup, run `sudo tailscale up` and follow the authentication URL
- Check Tailscale status with `tailscale status`
- For GCE subnet routing: Approve routes in Tailscale admin console under Machine settings
- Get Tailscale auth keys from https://login.tailscale.com/admin/settings/keys
- If subnet routing doesn't work, check that IP forwarding is enabled: `cat /proc/sys/net/ipv4/ip_forward` should show `1`