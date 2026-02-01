#!/bin/bash

# リリース日マッピング
declare -A RELEASE_DATES=(
    ["2.1.0"]="2026-01-07"
    ["2.1.2"]="2026-01-09"
    ["2.1.3"]="2026-01-09"
    ["2.1.4"]="2026-01-11"
    ["2.1.5"]="2026-01-12"
    ["2.1.6"]="2026-01-13"
    ["2.1.7"]="2026-01-14"
    ["2.1.9"]="2026-01-16"
    ["2.1.10"]="2026-01-16"
    ["2.1.11"]="2026-01-17"
    ["2.1.12"]="2026-01-17"
    ["2.1.14"]="2026-01-20"
    ["2.1.15"]="2026-01-21"
    ["2.1.16"]="2026-01-22"
    ["2.1.17"]="2026-01-22"
    ["2.1.18"]="2026-01-23"
    ["2.1.19"]="2026-01-23"
    ["2.1.20"]="2026-01-27"
    ["2.1.21"]="2026-01-28"
    ["2.1.22"]="2026-01-28"
    ["2.1.23"]="2026-01-29"
    ["2.1.25"]="2026-01-29"
    ["2.1.27"]="2026-01-30"
)

# changelogファイルを解析して、バージョンとエントリのペアを出力
parse_changelog() {
    local changelog_file="$1"
    local current_version=""
    local entry_index=0

    while IFS= read -r line; do
        # バージョン行をチェック
        if [[ "$line" =~ ^##[[:space:]]+(2\.1\.[0-9]+) ]]; then
            current_version="${BASH_REMATCH[1]}"
            entry_index=0
            continue
        fi

        # エントリ行をチェック（'- 'で始まる）
        if [[ "$line" =~ ^-[[:space:]](.+)$ ]]; then
            local entry_text="${BASH_REMATCH[1]}"
            local release_date="${RELEASE_DATES[$current_version]}"

            if [[ -n "$release_date" ]]; then
                echo "${current_version}|${release_date}|${entry_index}|${entry_text}"
                ((entry_index++))
            fi
        fi
    done < "$changelog_file"
}

# エントリから記事ファイル名を生成
generate_feature_name() {
    local entry="$1"
    local version="$2"
    local index="$3"

    # 主要キーワードを抽出（最初の数単語）
    local keywords=$(echo "$entry" | sed 's/^Added //' | sed 's/^Fixed //' | sed 's/^Improved //' | sed 's/^Changed //' | sed 's/^Removed //' | sed 's/^Deprecated //' | head -c 50)

    # kebab-caseに変換
    local feature_name=$(echo "$keywords" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$//')

    # 重複回避のためにバージョンとインデックスを追加
    echo "v${version//./-}-${index}-${feature_name}"
}

# メイン処理
main() {
    local changelog_file="data/last-known-changelog.md"
    local output_dir="docs/updates"
    local total_count=0

    echo "Parsing changelog..."

    # changelogを解析してエントリリストを生成
    while IFS='|' read -r version release_date index entry_text; do
        local feature_name=$(generate_feature_name "$entry_text" "$version" "$index")
        local output_file="${output_dir}/2026-01-31-${feature_name}.md"

        echo "${version}|${release_date}|${entry_text}|${output_file}"
        ((total_count++))
    done < <(parse_changelog "$changelog_file")

    echo ""
    echo "Total entries to process: $total_count"
}

main
