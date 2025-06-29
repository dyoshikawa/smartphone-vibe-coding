---
root: true
targets: ["*"]
description: "Project overview and general development guidelines"
globs: ["*"]
---

# TailscaleをGoogle Compute Engine (GCE)で運用するためのセットアップガイド

## 前提条件
- Tailscaleネットワーク（tailnet）が既にセットアップされ、少なくとも1つのデバイスが接続されていること

## セットアップ手順

### 1. VM設定
- VM作成時に、ネットワークインターフェース設定で「IP転送」を有効にする
- この設定はサブネットルーティング機能にとって重要

### 2. Tailscaleのインストール
- LinuxのVMに標準的なLinuxインストール方法でTailscaleをインストール
- 通常のLinux向けTailscaleインストールガイドに従う

### 3. ファイアウォール設定
- IPv4とIPv6の両方でUDPポート41641を許可
- 2つのファイアウォールルールを作成：
  1. 送信元0.0.0.0/0からUDPポート41641への受信ルール
  2. 送信元::/0からUDPポート41641への受信ルール

### 4. ルート広告設定
- 以下のコマンドを使用：
  ```bash
  tailscale set --advertise-routes=10.182.0.0/24 --accept-dns=false
  ```
- サブネットは特定のGCEネットワーク範囲に置き換える
- GoogleにDNS設定を処理させるため、DNS受け入れを無効にする

### 5. DNS設定
- Google Cloud CLIを使用してDNSポリシーを作成
- Google Cloud DNSリゾルバーをTailscale DNS設定に追加
- DNSが「internal」検索ドメインに制限されることを確認

### 6. セキュリティ推奨事項
- Tailscale設定後はパブリックSSHアクセスを削除

## 追加のベストプラクティス

### 認証キー
- 自動デプロイメントには認証キーを使用

### デバイス管理
- デバイス管理にタグの使用を検討

### ネットワークセグメンテーション
- ネットワークセグメンテーションにサブネットルーティングを実装

## 技術的詳細

### 必要なポート
- UDPポート41641（Tailscale通信用）

### ネットワーク要件
- IP転送の有効化（VM作成時に設定）
- 適切なファイアウォールルール

### DNS考慮事項
- Google CloudのDNS処理を活用
- internalドメインの使用
- Tailscale DNS受け入れの無効化

参考URL: https://tailscale.com/kb/1147/cloud-gce
