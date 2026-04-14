# fuklet Usage Guide

## Basic Usage

```
/fuklet /path/to/folder
/fuklet /path/to/file.md
```

## How It Works

1. **Path validation**: The skill checks if the path exists
2. **Content reading**: Files are read and sorted alphabetically
3. **Chapter generation**: Each file becomes a chapter (max 20)
4. **Page building**: Content is split into front/back pages
5. **HTML generation**: A self-contained HTML flipbook is created
6. **Browser open**: The flipbook opens in your default browser
7. **Catalog update**: `books.json` is updated with the new entry

## Input Formats

### Folder Input

When you pass a folder path, fuklet:

- Reads all files in the folder (recursively, sorted by name)
- Skips binary files with a warning
- Limits to 20 files (excess merged into final chapter)
- Uses folder name as the book title

### Single File Input

When you pass a file path, fuklet:

- Reads the file content
- Uses filename (without extension) as the book title
- Splits content across pages automatically

### Supported File Types

- `.md` - Markdown (primary)
- `.txt` - Plain text
- `.html` - HTML (content extracted)
- `.json` - JSON (formatted as code block)
- Other text files are included but marked as non-markdown

## Output

The flipbook is saved to:

```
/tmp/claude/fuklet/{slug}-{timestamp}.html
```

Where:
- `slug` is derived from the folder/filename (kebab-case)
- `timestamp` is `YYYYMMDD-HHMMSS`

## Bookshelf

To browse all generated flipbooks:

```bash
cd /path/to/fuklet
npx serve .
# Open http://localhost:3000/bookshelf.html
```

The bookshelf displays:
- 3D wooden shelves with book spines
- Click to open a flipbook in reader mode
- Sort by date (new/old) or by chapter count
- Drag-and-drop reorder books on shelf
- Keyboard navigation (Arrow keys, Space, Escape)

## CSS Classes for Content

Inside flipbook pages, use these CSS classes:

| Class | Purpose |
|-------|---------|
| `.page-title` | Large heading |
| `.chapter-label` | Chapter number |
| `.page-body` | Body text |
| `.code-block` | Code with syntax highlighting (`.comment`, `.keyword`, `.string`, `.property`) |
| `.quote` | Blockquote |
| `.tip-box` | Tip/note box with `.tip-title` |
| `.comparison` | Two-column comparison (`.col.good` / `.col.bad`) |
| `.divider` | Decorative separator |
| `.dropcap` | Drop cap first letter |
| `.tag` | Inline tag/badge |
