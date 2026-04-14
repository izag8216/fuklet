---
name: fuklet
description: Generate 3D page-flipping flipbooks from any file or folder
---

# fuklet

Turn any folder or file into a beautiful 3D page-flipping flipbook.

## Trigger

- `/fuklet {path}` where `{path}` is a file or folder
- "fuklet /path/to/folder"

## Processing Flow

### Step 1: Validate Path

Run generate.sh to collect file/folder content:

```bash
SCRIPT_DIR="$(dirname "$0")"
bash "$SCRIPT_DIR/skill/generate.sh" "{path}"
```

**Error handling:**
- Exit code 1: "Path not found" -> report to user, stop
- Exit code 2: "No readable files" -> report to user, stop
- Success: Note the output file path printed at the end

### Step 2: Read and Structure Content

Read the output file from Step 1. Parse the structured format:

```
SLUG=chapter-slug
SOURCE=/path/to/source
TYPE=file|folder
DATE=2026-04-14
TITLE=Chapter Slug
TOTAL_FILES=N
---FILE_LIST---
file1.md
file2.md
---FILE_LIST_END---
---FILE_START---
FILE: filename.md
INDEX: 1
EXT: md

(file content here)

---FILE_END---
```

**Parsing rules:**
- Extract `SLUG`, `TITLE`, `DATE` from header
- Split into per-file sections using `---FILE_START---` / `---FILE_END---` delimiters
- Each file section becomes one chapter

### Step 3: Build Chapter Structure

Convert parsed file sections into structured chapters:

**Chapter structure:**
```
{
  chapterTitle: string,    // From filename: strip ext, replace hyphens with spaces, capitalize
  chapterIndex: number,    // 1-based
  frontContent: string,    // HTML for front page
  backContent: string,     // HTML for back page (overflow content or next section)
  leftContent: string      // HTML for left page (previous chapter's back or cover spine)
}
```

**Content splitting rules:**
- Front matter (YAML between `---` markers): extract as metadata, strip from content
- Content exceeding ~300 words: split at paragraph boundary into front/back pages
- Preserve markdown formatting: convert to appropriate CSS classes
- Code blocks (```...```) -> `.code-block` HTML
- Blockquotes (> ...) -> `.quote` HTML
- Lists (- ...) -> `<ul>` or `<ol>` HTML
- Headings (## ...) -> `.page-title` HTML

**Chapter naming:**
- Strip file extension
- Replace hyphens/underscores with spaces
- Capitalize first letter of each word
- Example: `01-getting-started.md` -> "Getting Started"

**Max 20 chapters**: If more files exist, the last chapter contains merged content (handled by generate.sh).

### Step 4: Generate Flipbook HTML

Read `skill/template.html` and populate it with chapter data.

**Template placeholders:**
- `{{BOOK_TITLE}}` -> Title from Step 2
- `{{PAGES_DATA}}` -> JSON array of page objects

**Page object format (inline in the `pages` array):**
```javascript
{
  front: `<div class="cover-front">...(cover HTML)...</div>`,
  back: `<div class="page-number">ii</div>...(intro content)...</div>`,
  leftContent: `<div class="cover-left">...(spine)...</div>`
}
```

**Cover page (first page):**
```html
<div class="cover-front" style="position:absolute;inset:0;padding:50px;border-radius:0 10px 10px 0;">
  <div class="cover-ornament">&#9671; &#9671; &#9671;</div>
  <div class="cover-title">{TITLE}</div>
  <div class="cover-subtitle">── {DATE} ──</div>
  <div style="width:80px;height:1px;background:linear-gradient(to right,transparent,#2D5A27,transparent);margin:24px 0;"></div>
  <div class="cover-author">{chapter_count} chapters</div>
  <div class="cover-ornament">&#9671; &#9671; &#9671;</div>
</div>
```

**Chapter pages:**
```html
<!-- Front -->
<div class="page-number">{page_num}</div>
<div class="chapter-label">第{chapter_num}章</div>
<div class="page-title">{chapter_title}</div>
<div class="divider">&#9671; &#9671; &#9671;</div>
<div class="page-body">
  {content for front page}
</div>
<div class="flip-hint">ドラッグでめくる &#10148;</div>

<!-- Back -->
<div class="page-number">{page_num+1}</div>
<div class="page-body">
  {overflow content or next section}
</div>
```

**Output path:** `/tmp/claude/fuklet/{slug}-{timestamp}.html`

```bash
OUTPUT_DIR="/tmp/claude/fuklet"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT_FILE="$OUTPUT_DIR/$SLUG-$TIMESTAMP.html"
mkdir -p "$OUTPUT_DIR"
```

**Generation process:**
1. Read `skill/template.html`
2. Build the `pages` JavaScript array with all chapter data
3. Replace `{{BOOK_TITLE}}` with the title
4. Replace `// {{PAGES_DATA}}` with the actual pages array entries
5. Write the complete HTML to the output file

### Step 5: Open Browser and Update Catalog

**Open in browser:**
```bash
open "$OUTPUT_FILE"
```

**Update books.json:**
1. Read current `books.json` (in SKILL.md directory)
2. Append new entry:
```json
{
  "id": "{slug}",
  "title": "{TITLE}",
  "date": "{YYYY-MM-DD}",
  "day": "{weekday}",
  "file": "/tmp/claude/fuklet/{slug}-{timestamp}.html",
  "source": "{original source path}",
  "sessions": {chapter_count},
  "chapters": ["Chapter 1 Title", "Chapter 2 Title", ...],
  "color": {random 0-15},
  "pages": [
    {
      "front": "...(HTML)...",
      "back": "...(HTML)...",
      "leftContent": "...(HTML)..."
    }
  ]
}
```
3. Write updated `books.json`

**Color index:** `Math.floor(Math.random() * 16)` for spine color variety on the bookshelf.

## CSS Classes Reference

Available in template.html for content styling:

| Class | Purpose |
|-------|---------|
| `.page-title` | Large heading (Shippori Mincho, 28px) |
| `.chapter-label` | Chapter number (11px, fuku-accent color) |
| `.page-body` | Body text (15px, line-height 2) |
| `.code-block` | Code with `.comment`, `.keyword`, `.string`, `.property` |
| `.quote` | Blockquote with left border |
| `.tip-box` | Tip/note with `.tip-title` + `<ul>` |
| `.comparison` | Two-column `.col.good` / `.col.bad` |
| `.divider` | Decorative separator (ornament characters) |
| `.dropcap` | Drop cap first letter (52px) |
| `.tag` | Inline tag badge |
| `.cover-front` | Cover page styling |
| `.cover-left` | Cover spine (left side) |

## Color Tokens

fuku brand colors in `:root` CSS custom properties:

```css
--fuku-primary:   #2D5A27;  /* Deep forest green */
--fuku-secondary: #3A6B8C;  /* Sea blue */
--fuku-accent:    #E67E22;  /* Warm orange */
--fuku-warm:      #F5D76E;  /* Golden yellow */
--fuku-neutral:   #8B7355;  /* Earth brown */
--fuku-base:      #FDF6E3;  /* Cream white */
```

## Notes

- Binary files are skipped by generate.sh with a warning
- Symlinks are followed (read the target)
- Very large folders are limited to 20 chapters (excess merged into final chapter)
- Non-markdown files (.txt, .html, .json) are included but formatted appropriately
- The generated HTML is fully self-contained (no external dependencies except Google Fonts)
- books.json entries are append-only; existing entries are never modified
