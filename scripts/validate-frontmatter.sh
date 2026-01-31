#!/bin/bash
# Frontmatterの構文検証（基本的なチェック）

error_count=0

for file in docs/updates/2026-01-31-v2-1-0-*.md; do
  if [ ! -f "$file" ]; then
    continue
  fi

  # Frontmatterの存在チェック
  if ! grep -q "^---" "$file"; then
    echo "ERROR in $file: No frontmatter found"
    ((error_count++))
    continue
  fi

  # title, date, tagsの存在チェック
  if ! grep -q "^title:" "$file"; then
    echo "ERROR in $file: Missing title field"
    ((error_count++))
  fi

  if ! grep -q "^date:" "$file"; then
    echo "ERROR in $file: Missing date field"
    ((error_count++))
  fi

  if ! grep -q "^tags:" "$file"; then
    echo "ERROR in $file: Missing tags field"
    ((error_count++))
  fi
done

if [ $error_count -eq 0 ]; then
  echo "All frontmatter valid"
  exit 0
else
  echo "Found $error_count errors"
  exit 1
fi
