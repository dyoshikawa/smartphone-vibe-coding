# 開発環境セットアップ用Ansibleプレイブック

このAnsibleプレイブックは、Ubuntuサーバー上での開発環境セットアップを自動化します。含まれる機能：

- Git設定
- mise、Node.js、Claude Codeのインストール
- GitHub CLIのインストール
- root以外のユーザー設定でのDockerインストール
- Tailscaleインストール

## 前提条件

- ローカルマシンにAnsibleがインストールされていること
- 対象のUbuntuサーバーへのSSHアクセス
- 対象サーバーでのsudo権限

## セットアップ

1. **インベントリファイルの更新**

   `inventory.ini`を編集して、実際のサーバー詳細に置き換えます：

   ```ini
   [ubuntu_servers]
   server1 ansible_host=YOUR_SERVER_IP ansible_user=YOUR_USERNAME ansible_ssh_private_key_file=~/.ssh/smartphone_vibe_coding
   ```

2. **変数ファイルの作成（オプション）**

   サンプル変数ファイルをコピーして、Git設定で構成します：

   ```bash
   cp vars.example.yml vars.yml
   ```

   `vars.yml`を実際の値で編集：

   ```yaml
   git_name: "Your Name"
   git_email: "your.email@example.com"
   
   # オプション: Tailscale自動設定
   tailscale_auth_key: "tskey-auth-your-key-here"
   tailscale_advertise_routes: true
   ```

## 使用方法

### 基本的な使用方法（Git設定なし）

```bash
ansible-playbook -i inventory.ini playbook.yml
```

### Git設定あり

```bash
ansible-playbook -i inventory.ini playbook.yml -e "git_name='Your Name'" -e "git_email='your.email@example.com'"
```

### 変数ファイルを使用

```bash
ansible-playbook -i inventory.ini playbook.yml -e @vars.yml
```

## プレイブックの実行内容

### Git設定（`tasks/git_config.yml`）
- グローバルGitユーザー名とメールアドレスの設定
- デフォルトブランチを`main`に設定
- プル戦略をマージに設定（リベースなし）

### 開発ツール（`tasks/dev_tools.yml`）
- miseパッケージマネージャーのインストール
- mise経由でのNode.js 24のインストール
- npmでのClaude Codeのグローバルインストール
- シェル環境の設定

### GitHub CLI（`tasks/github_cli.yml`）
- GitHub CLIリポジトリの追加
- GitHub CLIのインストール
- `gh auth login`コマンドの準備

### Docker（`tasks/docker.yml`）
- Docker Engineと関連パッケージのインストール
- Dockerサービスの開始と有効化
- dockerグループへのユーザー追加（root以外のアクセス）
- インストールの確認

### Tailscale（`tasks/tailscale.yml`）
- TailscaleリポジトリとGPGキーの追加
- Tailscaleのインストール
- Tailscaleサービスの開始と有効化
- ルートアドバタイズ用のGCEネットワークサブネットの自動検出
- GCEサブネットルーティング用のTailscale設定（認証キーが提供されている場合）
- 手動設定用のセットアップスクリプトの作成
- ネットワーク認証の準備

## インストール後の手順

プレイブックを実行した後、次の作業が必要な場合があります：

1. **シェル環境の再読み込み**でmiseを有効化：
   ```bash
   exec $SHELL -l
   ```

2. **GitHub CLIでの認証**：
   ```bash
   gh auth login
   ```

3. **Dockerのroot以外のアクセスの確認**（ログアウト/ログインが必要な場合があります）：
   ```bash
   docker run hello-world
   ```

4. **Tailscaleネットワークへの接続**：
   
   `vars.yml`で認証キーを提供した場合、Tailscaleは自動的に設定されるはずです。
   
   そうでない場合は、手動で認証してください：
   ```bash
   sudo tailscale up
   ```
   提供された認証リンクに従ってください。
   
   GCEサブネットルーティングの場合、生成されたセットアップスクリプトを実行：
   ```bash
   ./setup-tailscale-gce.sh
   ```

5. **Claude Codeの開始**：
   ```bash
   claude
   ```

## ファイル構造

```
ansible/
├── README.md
├── README.ja.md          # 日本語版README
├── playbook.yml          # メインプレイブック
├── inventory.ini         # サーバーインベントリ
├── vars.example.yml      # サンプル変数ファイル
└── tasks/
    ├── git_config.yml    # Git設定タスク
    ├── dev_tools.yml     # mise、Node.js、Claude Code
    ├── github_cli.yml    # GitHub CLIインストール
    ├── docker.yml        # Dockerインストールとセットアップ
    └── tailscale.yml     # Tailscaleインストール
```

注：`vars.yml`はgitignoreされており、`vars.example.yml`をコピーして作成する必要があります。

## トラブルシューティング

- Dockerコマンドで`sudo`が必要な場合、グループ変更を有効にするためにログアウト・ログインが必要な場合があります
- Claude Codeが見つからない場合は、miseを有効化するためにシェル環境が再読み込みされていることを確認してください
- GitHub CLI認証の問題については、[GitHub CLI ドキュメント](https://cli.github.com/manual/)を参照してください
- Tailscaleセットアップについては、`sudo tailscale up`を実行して認証URLに従ってください
- Tailscaleステータスは`tailscale status`で確認してください
- GCEサブネットルーティング：Tailscale管理コンソールのマシン設定でルートを承認してください
- Tailscale認証キーは https://login.tailscale.com/admin/settings/keys から取得できます
- サブネットルーティングが動作しない場合は、IPフォワーディングが有効になっていることを確認してください：`cat /proc/sys/net/ipv4/ip_forward`で`1`が表示されるはずです