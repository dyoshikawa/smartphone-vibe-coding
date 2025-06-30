# スマートフォン Vibe Coding

スマートフォンからクラウドインスタンス上のClaude Codeに接続し、モバイルデバイスから「Vibe Coding」を実現するためのリポジトリです。

## 概要

このプロジェクトは、リモートコーディングセッションのためのコスト効率の良いクラウド環境をInfrastructure as Codeで構築します。Google Cloud Platform上に管理されたコンピューティングインスタンスを作成し、必要な時だけ起動・停止できるようにすることで、モバイルデバイスからアクセス可能な強力なコーディング環境を提供しながらコストを最小限に抑えます。

主な特徴：
- 月額定額制のClaude Code（APIキー従量課金ではありません）
- コンピューティングコストを最小化するオンデマンドインスタンス管理
- 毎日午前0時（日本時間）の自動シャットダウン
- 一貫したアクセスのための静的IPアドレス
- [Termius](https://termius.com/) SSHクライアントによるモバイルフレンドリーなアクセス

## アーキテクチャ

インフラストラクチャには以下が含まれます：
- **コンピューティングインスタンス**: e2-micro上のUbuntu 22.04 LTS（無料枠対象）
- **Cloud Functions**: インスタンスの起動・停止用HTTPトリガー関数
- **Cloud Scheduler**: 毎日午前0時（日本時間）の自動シャットダウン
- **静的IP**: SSHアクセス用の永続的なIPアドレス

## 前提条件

- Terraform（バージョン要件は後日指定）
- 課金が有効なGoogle Cloud Platformアカウント
- 適切な権限で設定されたgcloud CLI
- Claude Codeサブスクリプション
- iOS/AndroidデバイスのTermiusアプリ

## クイックスタート

1. このリポジトリをクローン
2. `googlecloud`ディレクトリに移動
   - Google Cloudの詳細なセットアップ手順については、[googlecloud/README.ja.md](googlecloud/README.ja.md)を参照してください
3. `terraform.tfvars`でTerraform変数を設定：
   ```hcl
   project_id     = "your-gcp-project-id"
   project_number = "your-gcp-project-number"
   ```
4. インフラストラクチャをデプロイ：
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
5. デプロイ後、Terraformは以下を出力します：
   - インスタンス起動URL
   - インスタンス停止URL
   - 静的IPアドレス

## 使用方法

### インスタンスの起動
- HTTP経由: Terraform出力で提供される起動URLにアクセス
- CLI経由: `gcloud compute instances start managed-instance --zone=asia-northeast1-a`

### インスタンスの停止
- HTTP経由: Terraform出力で提供される停止URLにアクセス
- CLI経由: `gcloud compute instances stop managed-instance --zone=asia-northeast1-a`
- 自動: インスタンスは毎日午前0時（日本時間）に停止

### モバイルからの接続
1. モバイルデバイスにTermiusをインストール
2. 静的IPアドレスで新しいホストを作成
3. 認証用のSSHキーを設定
4. 接続してコーディング開始！

## 開発環境のセットアップ

### 自動セットアップ（推奨）

プロジェクトには開発環境を自動的にセットアップするAnsibleプレイブックが含まれています：

1. インスタンスに接続後、このリポジトリをクローンします
2. `ansible`ディレクトリに移動します
3. [ansible/README.ja.md](ansible/README.ja.md)のセットアップ手順に従います
4. プレイブックが以下を自動的にインストールします：
   - Git設定
   - mise、Node.js、Claude Code
   - GitHub CLI
   - Docker

### 手動セットアップ

代替案として、[公式ドキュメント](https://docs.anthropic.com/claude-code)に従ってClaude Codeを手動でインストールすることもできます。

詳細なセットアップ手順については、[googlecloud/README.ja.md](googlecloud/README.ja.md)を参照してください。

## コスト最適化

- e2-microインスタンスを使用（無料枠対象）
- 24時間365日の課金を防ぐ毎日の自動シャットダウン
- HTTPエンドポイント経由のオンデマンド起動・停止
- SSHクライアントでの変更が不要な静的IP

## TODO

- [ ] AWS実装
- [x] Google Cloud実装

## セキュリティに関する考慮事項

- Cloud Functionsは公開アクセス可能（認証の追加を検討）
- SSHアクセスはキーベース認証で保護する必要があります
- 追加のセキュリティのためIP許可リストの実装を検討

## コントリビューション

プルリクエストを歓迎します。大きな変更については、まず変更したい内容を議論するためにIssueを開いてください。

## ライセンス

MIT
