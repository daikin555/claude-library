#!/bin/bash

# Claude Code Changelog記事カバレッジチェックスクリプト
# 新機能（Added/Improved/Changed）とバグ修正（Fixed）を分けてカウント

set -e

CHANGELOG_FILE="data/last-known-changelog.md"
DOCS_DIR="docs/updates"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Claude Code Changelog Coverage Check ===${NC}"
echo ""

VERSIONS=$(grep "^## " "$CHANGELOG_FILE" | grep "2\.1\." | sed 's/^## //' | head -10)

TOTAL_MISSING_FEATURES=0
TOTAL_MISSING_FIXES=0
TOTAL_VERSIONS=0

for VERSION in $VERSIONS; do
    TOTAL_VERSIONS=$((TOTAL_VERSIONS + 1))

    NEXT_VERSION=$(grep "^## " "$CHANGELOG_FILE" | grep -A1 "^## $VERSION$" | tail -1 | sed 's/^## //')

    if [ "$VERSION" = "$NEXT_VERSION" ]; then
        ALL_ITEMS=$(sed -n "/^## $VERSION$/,\$p" "$CHANGELOG_FILE" | grep "^- ")
    else
        ALL_ITEMS=$(sed -n "/^## $VERSION$/,/^## $NEXT_VERSION$/p" "$CHANGELOG_FILE" | grep "^- ")
    fi

    # 新機能（Fixed以外）とバグ修正（Fixed）に分類
    FEATURE_COUNT=$(echo "$ALL_ITEMS" | grep -v "^- Fixed\|^- \[VSCode\] Fixed" | grep -c "^- " || true)
    FIX_COUNT=$(echo "$ALL_ITEMS" | grep -c "^- Fixed\|^- \[VSCode\] Fixed" || true)

    # 記事数をカウント
    ARTICLE_COUNT=$(ls -1 $DOCS_DIR/$VERSION-*.md 2>/dev/null | wc -l | tr -d ' ')

    echo -e "${BLUE}Version $VERSION:${NC}"
    echo "  Feature items (Added/Improved/Changed): $FEATURE_COUNT"
    echo "  Bug fix items (Fixed):                  $FIX_COUNT"
    echo "  Total articles:                         $ARTICLE_COUNT"

    MISSING_FEATURES=0
    if [ "$ARTICLE_COUNT" -lt "$FEATURE_COUNT" ]; then
        MISSING_FEATURES=$((FEATURE_COUNT - ARTICLE_COUNT))
        if [ $MISSING_FEATURES -lt 0 ]; then MISSING_FEATURES=0; fi
    fi

    MISSING_FIXES=0
    TOTAL_ITEMS=$((FEATURE_COUNT + FIX_COUNT))
    if [ "$ARTICLE_COUNT" -lt "$TOTAL_ITEMS" ]; then
        REMAINING=$((TOTAL_ITEMS - ARTICLE_COUNT))
        if [ $REMAINING -gt $MISSING_FEATURES ]; then
            MISSING_FIXES=$((REMAINING - MISSING_FEATURES))
        fi
    fi

    if [ $MISSING_FEATURES -gt 0 ]; then
        echo -e "  ${RED}✗ Missing feature articles: $MISSING_FEATURES${NC}"
        TOTAL_MISSING_FEATURES=$((TOTAL_MISSING_FEATURES + MISSING_FEATURES))
    elif [ $MISSING_FIXES -gt 0 ]; then
        echo -e "  ${YELLOW}⚠ Missing bug fix articles: $MISSING_FIXES (warning only)${NC}"
        TOTAL_MISSING_FIXES=$((TOTAL_MISSING_FIXES + MISSING_FIXES))
    else
        echo -e "  ${GREEN}✓ Complete coverage${NC}"
    fi

    echo ""
done

echo -e "${BLUE}=== Summary ===${NC}"
echo "Versions checked: $TOTAL_VERSIONS"

if [ $TOTAL_MISSING_FEATURES -eq 0 ]; then
    if [ $TOTAL_MISSING_FIXES -gt 0 ]; then
        echo -e "${YELLOW}⚠ Missing bug fix articles: $TOTAL_MISSING_FIXES (non-blocking)${NC}"
    fi
    echo -e "${GREEN}✓ All feature articles are covered!${NC}"
    echo "Total missing feature articles: 0"
    exit 0
else
    echo -e "${RED}✗ Total missing feature articles: $TOTAL_MISSING_FEATURES${NC}"
    if [ $TOTAL_MISSING_FIXES -gt 0 ]; then
        echo -e "${YELLOW}⚠ Also missing bug fix articles: $TOTAL_MISSING_FIXES (non-blocking)${NC}"
    fi
    echo ""
    echo -e "${YELLOW}To generate missing articles, run:${NC}"
    echo "  python scripts/generate_articles.py"
    exit 1
fi
