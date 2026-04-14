<h1 align="center">fuklet</h1>

<p align="center">
  <strong>任意のファイルやフォルダを、3Dページめくりフリップブックに。</strong>
</p>

<p align="center">
  <a href="https://github.com/izag8216/fuklet/actions/workflows/ci.yml">
    <img src="https://github.com/izag8216/fuklet/actions/workflows/ci.yml/badge.svg" alt="CI">
  </a>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Claude%20Code-Skill-7c3aed" alt="Claude Code Skill">
</p>

<p align="center">
  <a href="README.md">English</a> &middot;
  <a href="docs/usage.md">Usage Guide</a> &middot;
  <a href="CHANGELOG.md">Changelog</a>
</p>

---

## fukletとは

fuklet は [Claude Code](https://claude.ai/code) スキルで、ファイルやフォルダをブラウザで読めるインタラクティブな3Dフリップブックに変換します。ページをドラッグでめくり、Web Audioで紙の音が鳴り、3D本棚でコレクションを閲覧できます。

[gonta223/cc-books](https://github.com/gonta223/cc-books) をベースに、JSONLセッションログ入力を汎用的なファイル/フォルダ入力に置き換え、fukuブランドカラーパレットを適用したフォーク改変版です。

**従来:** Claude Codeのセッションログからしかフリップブックを作れなかった  
**fuklet:** Markdownフォルダ、ドキュメント一式、テキストファイルの何でもフリップブックに

## デモ

<!-- スクリーンショットは準備中 -->
```
/fuklet ./my-docs
```

生成されるフリップブック:
- 深緑のグラデーション表紙
- ファイルごとに1章、自動ページ分割
- ドラッグでめくり（50度しきい値、バネ戻り）
- めくり時に紙の音が鳴る
- キーボード操作（矢印キー、Space、Escape）

## クイックスタート

```bash
# 1. クローン
git clone https://github.com/izag8216/fuklet.git
cd fuklet

# 2. Claude Codeで使用
/fuklet /path/to/folder
# または
/fuklet /path/to/file.md
```

フリップブックがブラウザで開きます。出力先は `outputs/`。

## 使い方

### フォルダから生成

```
/fuklet ./docs
```

- 各ファイルが1章になる（最大20章、超過分は最終章に統合）
- ファイル名でアルファベット順ソート
- バイナリファイルは警告付きでスキップ
- フォルダ名が本のタイトルに

### 単一ファイルから生成

```
/fuklet ./notes/my-notes.md
```

- 内容が自動でページ分割（約300語/ページ）
- ファイル名がタイトルに
- YAMLフロントマター（`---`ブロック）はメタデータとして抽出

### 本棚

生成済みのフリップブックを3D木製本棚で閲覧:

```bash
npx serve .
# http://localhost:3000/bookshelf.html を開く
```

機能:
- 本をクリックでリーダー起動
- 日付順・章数順でソート
- ドラッグ&ドロップで並べ替え
- キーボード操作: Escape で閉じる、矢印キーでめくり

### 入力収集スクリプト単体使用

`generate.sh` は単体でも使えます:

```bash
./skill/generate.sh /path/to/folder
# 出力: outputs/input_{timestamp}.txt
```

| 終了コード | 意味 |
|:----------:|------|
| `0` | 成功 |
| `1` | パスが見つからない |
| `2` | 読み込み可能なファイルがない |

## 出力

| 項目 | 場所 | 備考 |
|------|------|------|
| フリップブック HTML | `outputs/{slug}-{timestamp}.html` | 自己完結、サーバー不要 |
| カタログ | `books.json` | 追記専用、cc-books互換スキーマ |
| 本棚 | `bookshelf.html` | 3D棚UI + 埋め込みリーダー |

`outputs/` は `.gitignore` 対象 -- 生成物はローカルに留まります。

## 機能一覧

| 機能 | 説明 |
|------|------|
| 柔軟な入力 | `/fuklet {path}` でファイルまたはフォルダを指定 |
| 3Dページめくり | CSS 3D transforms + ドラッグ物理 + バネ戻り |
| Web Audio | 合成紙音（めくり + ざわめき） |
| 本棚UI | 3D木製棚 + ドラッグ並べ替え + ソート + 埋め込みリーダー |
| 自己完結 | 単一HTML、サーバー不要（Google FontsのみCDN） |
| ブランドカラー | fukuパレット: 深緑、海青、福オレンジ |
| 自動章分割 | 300語超で段落境界で前後ページに分割 |
| バイナリ安全 | バイナリスキップ、シンボリックリンク対応 |

## アーキテクチャ

```
/fuklet {path}
     |
     v
[SKILL.md] -- パス解析 --> 存在確認
     |
     v
[generate.sh] -- 判定 --> ファイル | フォルダ
     |                          |
     v                          v
[章分割] -- 内容 --> chapters[]
     |
     v
[ページ構築] -- chapters[] --> pages[]
     |
     v
[HTML生成] -- template.html + pages[] --> 単一HTML
     |
     v
[カタログ更新 + ブラウザ起動] --> books.json追記 + ブラウザで開く
```

## カラーパレット

fukuブランドトークンをCSSカスタムプロパティで適用:

| トークン | Hex | 役割 |
|----------|-----|------|
| `--fuku-primary` | `#2D5A27` | 深緑 -- タイトル、章ラベル |
| `--fuku-secondary` | `#3A6B8C` | 海青 -- 引用、区切り、ティップス罫線 |
| `--fuku-accent` | `#E67E22` | 福オレンジ -- 装飾、ドロップキャップ、ハイライト |
| `--fuku-warm` | `#F5D76E` | 黄金色 -- 補助アクセント |
| `--fuku-neutral` | `#8B7355` | 茶土 -- ページ番号、控えめテキスト |
| `--fuku-base` | `#FDF6E3` | クリーム -- ページ背景 |

## プロジェクト構成

```
fuklet/
  SKILL.md                # Claude Code スキルエントリポイント（5ステップパイプライン）
  skill/
    generate.sh           # 入力収集（ファイル/フォルダ → 構造化テキスト）
    template.html         # フリップブックHTMLテンプレート（fukuカラー）
  bookshelf.html          # 3D本棚UI + 埋め込みリーダー
  books.json              # フリップブックカタログ（追記専用）
  docs/
    usage.md              # 詳細使い方ガイド
  .github/
    workflows/ci.yml      # CI: ShellCheck + JSON検証 + ビルドテスト
    ISSUE_TEMPLATE/       # バグ報告 + 機能リクエスト
    PULL_REQUEST_TEMPLATE.md
```

## コントリビューション

[CONTRIBUTING.md](CONTRIBUTING.md) を参照してください。

1. Fork -> ブランチ作成（`feat/your-feature`）-> PR
2. push前に `shellcheck skill/generate.sh` を実行
3. Conventional Commits: `feat:`, `fix:`, `docs:`

## クレジット

[gonta223/cc-books](https://github.com/gonta223/cc-books)（MIT License）のフォーク改変版。  
フリップブックエンジン、本棚UI、ページめくり機構は色変更のみで再利用。  
詳細は [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md)。

## ライセンス

[MIT](LICENSE) &copy; 2026 fuku
