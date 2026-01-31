---
title: "Windows管理設定パスの変更（ProgramData→Program Files）"
date: 2026-01-09
tags: ['非推奨化', 'Windows', '管理者向け', '設定']
---

## 原文（日本語に翻訳）

Windows管理設定パス `C:\ProgramData\ClaudeCode\managed-settings.json` を非推奨化しました。管理者は `C:\Program Files\ClaudeCode\managed-settings.json` に移行してください。

## 原文（英語）

Deprecated Windows managed settings path `C:\ProgramData\ClaudeCode\managed-settings.json` - administrators should migrate to `C:\Program Files\ClaudeCode\managed-settings.json`

## 概要

Windows環境での管理設定ファイルの配置場所が、`C:\ProgramData\ClaudeCode\` から `C:\Program Files\ClaudeCode\` に変更されました。旧パスは非推奨となり、将来のバージョンでサポートが終了する予定です。企業のIT管理者は、新しいパスに設定を移行することが推奨されます。

## 基本的な使い方

### 旧パス（非推奨）

```powershell
# 旧パス（v2.1.2以降は非推奨）
C:\ProgramData\ClaudeCode\managed-settings.json

# このパスはまだ読み込まれますが、警告が表示されます
```

### 新パス（推奨）

```powershell
# 新パス（v2.1.2以降の推奨パス）
C:\Program Files\ClaudeCode\managed-settings.json

# このパスを使用してください
```

## 実践例

### 管理設定ファイルの移行

```powershell
# 管理者権限でPowerShellを起動

# 1. 旧設定ファイルをバックアップ
Copy-Item `
  "C:\ProgramData\ClaudeCode\managed-settings.json" `
  "C:\ProgramData\ClaudeCode\managed-settings.json.backup"

# 2. 新しい場所にディレクトリを作成（存在しない場合）
New-Item -ItemType Directory -Force `
  -Path "C:\Program Files\ClaudeCode"

# 3. 設定ファイルを新しい場所にコピー
Copy-Item `
  "C:\ProgramData\ClaudeCode\managed-settings.json" `
  "C:\Program Files\ClaudeCode\managed-settings.json"

# 4. 動作確認後、旧ファイルを削除（オプション）
# Remove-Item "C:\ProgramData\ClaudeCode\managed-settings.json"
```

### 企業環境でのグループポリシー設定更新

```powershell
# Active Directoryグループポリシーで配布する場合

# GPOスクリプト例
# \\domain\sysvol\domain\scripts\deploy-claude-settings.ps1

$newPath = "C:\Program Files\ClaudeCode"
$settingsFile = "managed-settings.json"

# ネットワーク共有から設定をコピー
Copy-Item `
  "\\fileserver\IT\claude-code\managed-settings.json" `
  "$newPath\$settingsFile" `
  -Force

Write-Host "Claude Code managed settings deployed to new location"
```

### 設定ファイルの内容例

```json
// C:\Program Files\ClaudeCode\managed-settings.json
{
  "version": "1.0",
  "managedBy": "IT Department",
  "settings": {
    "autoUpdate": false,
    "allowedPlugins": [
      "@company/security-scanner",
      "@company/code-formatter"
    ],
    "disabledFeatures": [
      "telemetry",
      "remote-sessions"
    ],
    "environmentVariables": {
      "CLAUDE_CODE_PROXY": "http://proxy.company.com:8080",
      "CLAUDE_CODE_CERT_PATH": "C:\\certs\\company-ca.pem"
    }
  }
}
```

### SCCMでの展開

```powershell
# SCCM パッケージ展開スクリプト

# インストール後スクリプト
$source = "\\deployment\claude-code\managed-settings.json"
$destination = "C:\Program Files\ClaudeCode\managed-settings.json"

# ディレクトリ作成
New-Item -ItemType Directory -Force -Path "C:\Program Files\ClaudeCode"

# 設定ファイル展開
Copy-Item $source $destination -Force

# アクセス権限設定（読み取り専用）
$acl = Get-Acl $destination
$acl.SetAccessRuleProtection($true, $false)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Users", "Read", "Allow"
)
$acl.AddAccessRule($rule)
Set-Acl $destination $acl

Write-Host "Managed settings deployed successfully"
```

## 注意点

- **移行期間**: 旧パスはまだサポートされていますが、非推奨です
- **管理者権限**: `C:\Program Files` への書き込みには管理者権限が必要です
- **優先順位**: 両方のパスに設定ファイルがある場合、新パスが優先されます
- **セキュリティ向上**: `Program Files` は `ProgramData` よりも変更が制限されるため、セキュリティが向上します
- **ユーザー設定との関係**: 管理設定はユーザー設定よりも優先されます

## 関連情報

- [Claude Code 公式ドキュメント](https://code.claude.com/docs/)
- [Changelog v2.1.2](https://github.com/anthropics/claude-code/releases/tag/v2.1.2)
- [Windows管理設定ガイド](https://code.claude.com/docs/windows-managed-settings)
