#!/bin/bash
# generate.sh - Collect file/folder content for fuklet flipbook generation
#
# Usage: ./generate.sh <path>
#   <path> can be a file or folder
#
# Output: outputs/input_{timestamp}.txt
#
# Exit codes:
#   0 - Success
#   1 - Path not found
#   2 - No readable files found

set -euo pipefail

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <path>"
  echo "  <path> can be a file or folder"
  exit 1
fi

# Resolve to absolute path
TARGET="$(cd "$(dirname "$TARGET")" 2>/dev/null && pwd)/$(basename "$TARGET")" || {
  echo "Error: Path not found: $1"
  exit 1
}

if [ ! -e "$TARGET" ]; then
  echo "Error: Path not found: $TARGET"
  exit 1
fi

OUTPUT_DIR="$(cd "$(dirname "$0")/.." && pwd)/outputs"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT_FILE="$OUTPUT_DIR/input_${TIMESTAMP}.txt"

mkdir -p "$OUTPUT_DIR"

# Generate slug from target name
SLUG="$(basename "$TARGET" | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')"

if [ -f "$TARGET" ]; then
  # ── Single file mode ──
  FILE_EXT="${TARGET##*.}"
  : # file size intentionally unused in output

  # Skip binary files (rough check)
  if file "$TARGET" 2>/dev/null | grep -qi "binary\|executable\|image\|audio\|video\|archive\|compressed"; then
    echo "Error: Binary file detected: $TARGET"
    echo "fuklet only supports text files."
    exit 2
  fi

  # Check if file is readable text
  if ! head -c 512 "$TARGET" > /dev/null 2>&1; then
    echo "Error: Cannot read file: $TARGET"
    exit 2
  fi

  {
    echo "SLUG=$SLUG"
    echo "SOURCE=$TARGET"
    echo "TYPE=file"
    echo "DATE=$(date +%Y-%m-%d)"
    echo "TITLE=$(basename "$TARGET" | sed 's/\.[^.]*$//' | tr '-' ' ' | sed 's/\b\(.\)/\u\1/')"
    echo "---FILE_START---"
    echo "FILE: $(basename "$TARGET")"
    echo "EXT: $FILE_EXT"
    echo ""
    cat "$TARGET"
    echo ""
    echo "---FILE_END---"
  } > "$OUTPUT_FILE"

  echo "Input collected: $TARGET"
  echo "Output: $OUTPUT_FILE"
  exit 0

elif [ -d "$TARGET" ]; then
  # ── Folder mode ──
  # Collect text files, sorted alphabetically, max 20
  FILES=()
  SKIPPED=0

  while IFS= read -r f; do
    [ -z "$f" ] && continue
    # Skip binary files
    if file "$f" 2>/dev/null | grep -qi "binary\|executable\|image\|audio\|video\|archive\|compressed"; then
      SKIPPED=$((SKIPPED + 1))
      continue
    fi
    FILES+=("$f")
  done < <(find "$TARGET" -type f -not -path "*/node_modules/*" -not -path "*/.git/*" -not -path "*/.obsidian/*" -not -name ".*" 2>/dev/null | sort)

  TOTAL=${#FILES[@]}

  if [ "$TOTAL" -eq 0 ]; then
    echo "Error: No readable files found in: $TARGET"
    if [ "$SKIPPED" -gt 0 ]; then
      echo "  ($SKIPPED binary files were skipped)"
    fi
    exit 2
  fi

  # Limit to 20 files
  MERGED=0
  if [ "$TOTAL" -gt 20 ]; then
    MERGED=$((TOTAL - 19))
  fi

  DISPLAY_TITLE="$(basename "$TARGET" | tr '-' ' ' | sed 's/\b\(.\)/\u\1/')"

  {
    echo "SLUG=$SLUG"
    echo "SOURCE=$TARGET"
    echo "TYPE=folder"
    echo "DATE=$(date +%Y-%m-%d)"
    echo "TITLE=$DISPLAY_TITLE"
    echo "TOTAL_FILES=$TOTAL"
    echo "SKIPPED=$SKIPPED"
    echo "MERGED=$MERGED"

    # List all files first (for chapter titles)
    echo ""
    echo "---FILE_LIST---"
    COUNT=0
    for f in "${FILES[@]}"; do
      COUNT=$((COUNT + 1))
      if [ "$COUNT" -le 20 ]; then
        basename "$f"
      elif [ "$COUNT" -eq 21 ]; then
        echo "[Merged: $(basename "$f")"
      else
        echo " + $(basename "$f")]"
      fi
    done
    echo "---FILE_LIST_END---"

    # Output file contents
    COUNT=0
    for f in "${FILES[@]}"; do
      COUNT=$((COUNT + 1))
      FILE_EXT="${f##*.}"

      if [ "$COUNT" -le 19 ]; then
        echo ""
        echo "---FILE_START---"
        echo "FILE: $(basename "$f")"
        echo "INDEX: $COUNT"
        echo "EXT: $FILE_EXT"
        echo ""
        cat "$f"
        echo ""
        echo "---FILE_END---"
      elif [ "$COUNT" -eq 20 ]; then
        # Last chapter: merge remaining files
        echo ""
        echo "---FILE_START---"
        echo "FILE: [Merged: $MERGED files]"
        echo "INDEX: $COUNT"
        echo "EXT: mixed"
        echo ""
        cat "$f"
        # Append remaining files
        for g in "${FILES[@]:20}"; do
          echo ""
          echo ""
          echo "---MERGED_SEPARATOR---"
          echo ""
          cat "$g"
        done
        echo ""
        echo "---FILE_END---"
      fi
    done
  } > "$OUTPUT_FILE"

  echo "Input collected: $TARGET"
  echo "Files: $TOTAL ($SKIPPED binary skipped)"
  if [ "$MERGED" -gt 0 ]; then
    echo "Note: $MERGED files merged into final chapter (20 chapter limit)"
  fi
  echo "Output: $OUTPUT_FILE"
  exit 0

else
  echo "Error: Path not found: $TARGET"
  exit 1
fi
