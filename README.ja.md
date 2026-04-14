# fuklet

> 任意のフォルダやファイルを美しい3Dページめくりフリップブックに変換

fuklet は [Claude Code](https://claude.ai/code) スキルで、指定したファイルやフォルダからインタラクティブなフリップブックを生成します。[cc-books](https://github.com/gonta223/cc-books) をベースに fuku ブランドカラーパレットを適用したフォーク改変版です。

[English README](README.md)

## 特徴

- **柔軟な入力**: `/fuklet {path}` でファイルまたはフォルダを指定
- **3Dページめくり**: CSS 3D transforms + ドラッグ操作の物理シミュレーション
- **Web Audio**: めくり時の紙の音
- **本棚UI**: 3D木製棚で全フリップブックを閲覧
- **自己完結**: 単一HTML出力、サーバー不要
- **fukuブランドカラー**: 深緑、海青、福オレンジのパレット

## 使い方

### フリップブックを生成

```
/fuklet /path/to/markdown/folder
```

フォルダ内の各ファイルが1章になります（最大20章、超過分は最終章に統合）。

### 単一ファイル

```
/fuklet /path/to/file.md
```

ファイルの内容が自動的にページに分割されます。

### 本棚

ブラウザで `bookshelf.html` を開いてください（`books.json` 読み込みにローカルサーバーが必要）:

```bash
npx serve .
```

## 出力先

| 項目 | 場所 |
|------|------|
| フリップブック HTML | `outputs/{slug}-{timestamp}.html` |
| カタログ | `books.json`（プロジェクトルート） |
| 本棚 | `bookshelf.html` |

## ファイル構成

```
fuklet/
  SKILL.md              # Claude Code スキルエントリポイント
  skill/
    generate.sh         # 入力収集スクリプト
    template.html       # フリップブック HTML テンプレート
  bookshelf.html        # 本棚 UI
  books.json            # フリップブックカタログ
```

## カラーパレット

fuku ブランドカラーを使用:

| トークン | 色 | 用途 |
|----------|-----|------|
| `--fuku-primary` | `#2D5A27` | 深緑 |
| `--fuku-secondary` | `#3A6B8C` | 海青 |
| `--fuku-accent` | `#E67E22` | 福オレンジ |
| `--fuku-base` | `#FDF6E3` | クリームホワイト |

## クレジット

[gonta223/cc-books](https://github.com/gonta223/cc-books)（MIT License）のフォーク改変版。

## ライセンス

MIT
