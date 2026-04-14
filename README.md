<h1 align="center">fuklet</h1>

<p align="center">
  <strong>Turn any file or folder into a 3D page-flipping flipbook.</strong>
</p>

<p align="center">
  <a href="https://github.com/izag8216/fuklet/actions/workflows/ci.yml">
    <img src="https://github.com/izag8216/fuklet/actions/workflows/ci.yml/badge.svg" alt="CI">
  </a>
  <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT">
  <img src="https://img.shields.io/badge/Claude%20Code-Skill-7c3aed" alt="Claude Code Skill">
</p>

<p align="center">
  <a href="README.ja.md">日本語</a> &middot; 
  <a href="docs/usage.md">Usage Guide</a> &middot;
  <a href="CHANGELOG.md">Changelog</a>
</p>

---

## What is fuklet?

fuklet is a [Claude Code](https://claude.ai/code) skill that converts your files and folders into interactive 3D flipbooks you can read in a browser. Drag pages to flip them, hear paper sounds via Web Audio, and browse your collection on a 3D bookshelf.

It is a fork-adapt of [cc-books](https://github.com/gonta223/cc-books), replacing the JSONL session-log input with a generic file/folder interface and applying the fuku brand color palette.

**Before fuklet:** You could only generate flipbooks from Claude Code session logs.  
**After fuklet:** Any markdown folder, documentation set, or text file becomes a flipbook.

## Demo

<!-- Add screenshots here when available -->
```
/fuklet ./my-docs
```

Generates a flipbook with:
- Cover page with forest-green aesthetic
- One chapter per file, content split across pages
- Drag-to-flip with physics (50-degree threshold, snap-back bounce)
- Paper sounds on every flip
- Keyboard navigation (Arrow keys, Space, Escape)

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/izag8216/fuklet.git
cd fuklet

# 2. Use in Claude Code
/fuklet /path/to/your/folder
# or
/fuklet /path/to/your/file.md
```

The flipbook opens in your default browser. Output is saved to `outputs/`.

## Usage

### From a Folder

```
/fuklet ./docs
```

- Each file becomes one chapter (max 20; excess merged into final chapter)
- Files sorted alphabetically
- Binary files skipped with warning
- Folder name used as book title

### From a Single File

```
/fuklet ./notes/my-notes.md
```

- File content split across pages automatically (~300 words per page)
- Filename used as book title
- Front matter (YAML `---` blocks) extracted as metadata

### Bookshelf

Browse all generated flipbooks on a 3D wooden shelf:

```bash
npx serve .
# Open http://localhost:3000/bookshelf.html
```

Features:
- Click a book to open the reader
- Sort by date or chapter count
- Drag-and-drop reorder
- Keyboard: Escape to close, Arrow keys to flip

### Input Collection Script

`generate.sh` can be used standalone:

```bash
./skill/generate.sh /path/to/folder
# Output: outputs/input_{timestamp}.txt
```

| Exit Code | Meaning |
|:---------:|---------|
| `0` | Success |
| `1` | Path not found |
| `2` | No readable files found |

## Output

| What | Where | Notes |
|------|-------|-------|
| Flipbook HTML | `outputs/{slug}-{timestamp}.html` | Self-contained, no server needed |
| Catalog | `books.json` | Append-only, schema-compatible with cc-books |
| Bookshelf | `bookshelf.html` | 3D shelf UI with embedded reader |

`outputs/` is gitignored -- generated files stay local.

## Features

| Feature | Description |
|---------|-------------|
| Flexible input | File or folder path via `/fuklet {path}` |
| 3D page-flip | CSS 3D transforms, drag-to-flip physics, snap-back bounce |
| Web Audio | Synthesized paper sounds (flip + rustle) on every interaction |
| Bookshelf UI | 3D wooden shelves with drag reorder, sort, and embedded reader |
| Self-contained | Single HTML file, no server or dependencies (except Google Fonts) |
| Brand colors | fuku palette: forest green, sea blue, warm orange |
| Chapter auto-split | Content over ~300 words split across front/back pages |
| Binary-safe | Skips binary files, follows symlinks, handles edge cases |

## Architecture

```
/fuklet {path}
     |
     v
[SKILL.md] -- parse path --> validate exists
     |
     v
[generate.sh] -- detect --> file | folder
     |                        |
     v                        v
[Chapter Splitter] -- content --> chapters[]
     |
     v
[Page Builder] -- chapters[] --> pages[]
     |
     v
[HTML Generator] -- template.html + pages[] --> single HTML
     |
     v
[Catalog + Browser] --> books.json append + open in browser
```

## Color Palette

fuku brand tokens applied via CSS custom properties:

| Token | Hex | Role |
|-------|-----|------|
| `--fuku-primary` | `#2D5A27` | Deep forest green -- titles, chapter labels |
| `--fuku-secondary` | `#3A6B8C` | Sea blue -- quotes, dividers, tip borders |
| `--fuku-accent` | `#E67E22` | Warm orange -- ornaments, dropcap, highlights |
| `--fuku-warm` | `#F5D76E` | Golden yellow -- secondary accents |
| `--fuku-neutral` | `#8B7355` | Earth brown -- page numbers, muted text |
| `--fuku-base` | `#FDF6E3` | Cream white -- page backgrounds |

## Project Structure

```
fuklet/
  SKILL.md                # Claude Code skill entry point (5-step pipeline)
  skill/
    generate.sh           # Input collection (file/folder -> structured text)
    template.html         # Flipbook HTML template (fuku colors)
  bookshelf.html          # 3D bookshelf UI with embedded reader
  books.json              # Flipbook catalog (append-only)
  docs/
    usage.md              # Detailed usage guide
  .github/
    workflows/ci.yml      # CI: ShellCheck + JSON validate + build test
    ISSUE_TEMPLATE/       # Bug report + feature request
    PULL_REQUEST_TEMPLATE.md
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

1. Fork -> Branch (`feat/your-feature`) -> PR
2. Run `shellcheck skill/generate.sh` before pushing
3. Conventional commits: `feat:`, `fix:`, `docs:`

## Credits

Fork-adapt of [cc-books](https://github.com/gonta223/cc-books) by gonta223 (MIT License).  
Flipbook engine, bookshelf UI, and page-flip mechanics are reused with color overrides.  
Full attribution in [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md).

## License

[MIT](LICENSE) &copy; 2026 fuku
