# Google Cloud セットアップガイド

このガイドでは、Terraformを使用してGoogle Cloud上に開発環境を構築し、必要な開発ツールをサーバーに設定する手順を説明します。

## 前提条件

- ローカルマシンにTerraformがインストールされていること
- 適切な権限を持つGoogle Cloudアカウント
- SSHとコマンドラインの基本的な知識

## ローカルマシンでの作業

### 1. SSHキーの生成

クラウドインスタンスへの安全な接続のためのSSHキーペアを生成します：

```bash
ssh-keygen -t ed25519 -f ~/.ssh/smartphone_vibe_coding -C "YOUR_EMAIL@example.com"
```

### 2. Terraform変数の設定

サンプル変数ファイルをコピーして、実際の値で設定します：

```bash
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars`を実際の値で編集します：
- `project_id`: Google CloudプロジェクトID
- `project_number`: Google Cloudプロジェクト番号
- `ssh_keys`: SSH公開鍵（形式: "username:ssh-rsa AAAAB3..."）

### 3. Terraformでインフラストラクチャをデプロイ

Google Cloudインフラストラクチャを初期化してデプロイします：

```bash
terraform init
terraform plan
terraform apply
```

### 4. サーバーへの接続

インフラストラクチャがデプロイされたら、SSHを使用してサーバーに接続します：

```bash
ssh -i ~/.ssh/smartphone_vibe_coding YOUR_USERNAME@IP_ADDRESS
```

`YOUR_USERNAME`を実際のユーザー名に、`IP_ADDRESS`をインスタンスのパブリックIPに置き換えてください。

## リモートサーバーでの設定

リモートサーバーに接続した後、以下の手順で開発環境をセットアップします。

### 1. Gitの設定

個人情報を使用してGitを設定します：

```bash
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
```

### 2. Claude Codeのインストール

miseパッケージマネージャーを使用してClaude Codeをインストールします：

```bash
# miseのインストール
curl https://mise.run | sh
echo "eval \"\$(/home/YOUR_USERNAME/.local/bin/mise activate bash)\"" >> ~/.bashrc
exec $SHELL -l

# Node.jsとClaude Codeのインストール
mise use node@24 --global
npm install -g @anthropic-ai/claude-code
```

### 3. GitHub CLIのインストール

GitHubとのシームレスな統合のために、公式のGitHub CLIをインストールします：

```bash
# GitHub CLIリポジトリの追加
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# GitHub CLIのインストール
sudo apt update -y
sudo apt install gh -y
```

### 4. GitHubでの認証

Personal Access Token（PAT）を使用してGitHub CLIを認証します：

```bash
gh auth login
```

プロンプトが表示されたら、GitHubのPersonal Access Tokenを貼り付けてください。

## その他のリソース

- [GitHub CLI ドキュメント](https://cli.github.com/manual/)
- [Claude Code ドキュメント](https://docs.anthropic.com/claude-code)
- [Google Cloud ドキュメント](https://cloud.google.com/docs)

## トラブルシューティング

問題が発生した場合：

1. すべての前提条件が適切にインストールされていることを確認してください
2. SSHキーに正しい権限が設定されていることを確認してください： `chmod 600 ~/.ssh/smartphone_vibe_coding`
3. Google Cloudの認証情報が適切に設定されていることを確認してください
4. ファイアウォールルールがポート22でのSSH接続を許可していることを確認してください