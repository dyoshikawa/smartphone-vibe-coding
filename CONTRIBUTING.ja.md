# Smartphone Vibe Codingへの貢献

Smartphone Vibe Codingプロジェクトへの貢献に興味を持っていただき、ありがとうございます！コミュニティからの貢献を歓迎し、どんな形でもご協力いただけることに感謝しています。

## はじめに

1. GitHubでリポジトリをフォークする
2. フォークをローカルにクローン：
   ```bash
   git clone https://github.com/your-username/smartphone-vibe-coding.git
   cd smartphone-vibe-coding
   ```
3. アップストリームリポジトリをリモートとして追加：
   ```bash
   git remote add upstream https://github.com/dyoshikawa/smartphone-vibe-coding.git
   ```

## 開発環境のセットアップ

### 前提条件

- Terraform
- Google Cloud Platformアカウント（課金が有効になっていること）
- 適切な権限で設定されたgcloud CLI
- Git
- mise（開発ツールバージョン管理ツール）
- Ansible（自動サーバーセットアップ用）
- サーバーアクセス用のSSHキーペア

### miseを使ったツールバージョン管理

このプロジェクトでは、開発ツールのバージョン管理に[mise](https://mise.jdx.dev/)を使用しています。まずmiseをインストールしてから、以下のコマンドを実行してください：

```bash
mise install
```

これにより、以下の正しいバージョンが自動的にインストールされます：
- Node.js (v24)
- pnpm (v10)

ツールバージョンはプロジェクトルートの`mise.toml`で定義されています。

## 変更の実施

1. 機能追加やバグ修正用の新しいブランチを作成：
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. コーディング規約に従って変更を実施：
   - 明確で自己文書化されたコードを書く
   - 既存のコードスタイルに従う
   - コミットを原子的に保ち、意味のあるコミットメッセージを書く
   - 新機能にはテストを追加する

3. 依存関係をインストールし、変更をテスト：
   ```bash
   pnpm install
   ```
   - Terraform設定の検証：`terraform validate`
   - Terraformフォーマットの確認：`terraform fmt -check`
   - 計画された変更のレビュー：`terraform plan`
   - Ansibleプレイブックのテスト：`ansible-playbook --syntax-check playbook.yml`
   - セキュリティチェックの実行：`pnpm run secretlint`

## プルリクエストの提出

1. 変更をフォークにプッシュ：
   ```bash
   git push origin feature/your-feature-name
   ```

2. GitHubでプルリクエストを作成：
   - 明確なタイトルと説明を提供
   - 関連するイシューを参照
   - UI変更の場合はスクリーンショットを含める
   - すべてのテストが通ることを確認

3. レビューを待つ：
   - フィードバックに迅速に対応
   - 要求された変更は新しいコミットで実施
   - 議論は集中的かつ専門的に行う

## コードスタイルガイドライン

- Terraformのベストプラクティスと規約に従う
- Ansibleプレイブック組織化のベストプラクティスに従う
- 既存のプロジェクト構造に従う
- 意味のある変数名と関数名を使用
- 関数は小さく、焦点を絞って作成
- 複雑なロジックにはコメントで文書化
- 適切な場所で型注釈を使用

## イシューの報告

- GitHubのイシュートラッカーを使用
- 新しいイシューを作成する前に既存のものを検索
- 明確な再現手順を提供
- 関連するシステム情報を含める
- 敬意を持って建設的に

## コミュニティガイドライン

- 歓迎的で包括的であること
- 異なる視点を尊重する
- 建設的なフィードバックを優雅に与え、受け取る
- コミュニティにとって最善のことに焦点を当てる
- 他者への共感を示す

## ライセンス

このプロジェクトへの貢献により、あなたの貢献がMITライセンスの下でライセンスされることに同意したものとみなされます。

## 質問がありますか？

貢献について質問がある場合は、お気軽に：
- ディスカッション用のイシューを開く
- プロジェクトのディスカッションで質問する
- メンテナーに連絡する

スマートフォンでのコーディングをよりアクセスしやすくするための貢献、ありがとうございます！