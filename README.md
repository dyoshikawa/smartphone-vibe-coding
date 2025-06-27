```bash
git config --global user.name "dyoshikawa"
git config --global user.email "dyoshikawa1993@gmail.com"
git config --global user.name "dyoshikawa-coding"
```

```bash
apt install -y
curl https://mise.run | sh
echo "eval \"\$(/home/dyoshikawa1993/.local/bin/mise activate bash)\"" >> ~/.bashrc
exec $SHELL -l
mise use node@24 --global
npm install -g @anthropic-ai/claude-code
```

https://github.com/cli/cli/blob/trunk/docs/install_linux.md

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
sudo apt update -y
sudo apt install gh -y
```

```bash
# https://cli.github.com/manual/gh_auth_login
# PATをペースト
gh auth login
```