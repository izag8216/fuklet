# fuklet

> Turn any folder or file into a beautiful 3D page-flipping flipbook.

fuklet is a [Claude Code](https://claude.ai/code) skill that generates interactive flipbooks from user-specified files or folders. Built as a fork-adapt of [cc-books](https://github.com/gonta223/cc-books) with the fuku brand color palette.

[Japanese README](README.ja.md)

## Features

- **Flexible input**: `/fuklet {path}` accepts a file or folder path
- **3D page-flip**: CSS 3D transforms with drag-to-flip physics
- **Web Audio**: Paper sounds on every page flip
- **Bookshelf UI**: Browse all generated flipbooks on a 3D wooden shelf
- **Self-contained**: Single HTML output, no server needed
- **fuku brand colors**: Deep forest green, sea blue, and warm orange palette

## Quick Start

```bash
# In Claude Code terminal:
/fuklet /path/to/folder
/fuklet /path/to/file.md
```

This generates a flipbook at `/tmp/claude/fuklet/{slug}-{timestamp}.html` and opens it in your browser.

## Usage

### Generate a FlipBook

```
/fuklet /path/to/markdown/folder
```

Each file in the folder becomes a chapter (max 20 chapters; excess files are merged into the final chapter).

### Single File

```
/fuklet /path/to/file.md
```

The file content is split into pages automatically.

### Bookshelf

Open `bookshelf.html` in a browser (with a local server for `books.json` loading):

```bash
npx serve .
```

## Output

| Item | Location |
|------|----------|
| Flipbook HTML | `/tmp/claude/fuklet/{slug}-{timestamp}.html` |
| Catalog | `books.json` (in project root) |
| Bookshelf | `bookshelf.html` |

## File Structure

```
fuklet/
  SKILL.md              # Claude Code skill entry point
  skill/
    generate.sh         # Input collection script
    template.html       # Flipbook HTML template
  bookshelf.html        # Bookshelf UI
  books.json            # Flipbook catalog
```

## Color Palette

fuklet uses the fuku brand colors:

| Token | Color | Usage |
|-------|-------|-------|
| `--fuku-primary` | `#2D5A27` | Deep forest green |
| `--fuku-secondary` | `#3A6B8C` | Sea blue |
| `--fuku-accent` | `#E67E22` | Warm orange |
| `--fuku-base` | `#FDF6E3` | Cream white |

## Credits

Fork-adapt of [cc-books](https://github.com/gonta223/cc-books) by gonta223 (MIT License).

## License

MIT
