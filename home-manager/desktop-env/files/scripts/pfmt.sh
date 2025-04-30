#!/usr/bin/env bash

# Usage: script.sh [-p start_path] [-b folder1,folder2,...] [-H]
#   -p: starting directory to search from (default: current directory)
#   -b: comma-separated list of folder names to blacklist (exclude from search)
#   -H: include hidden files and directories in the search (default: hidden items are excluded)

usage() {
    echo "Usage: $0 [-p start_path] [-b folder1,folder2,...] [-H]"
    exit 1
}

start_path="."
blacklist=()
include_hidden=false

while getopts "p:b:H" opt; do
    case $opt in
        p)
            start_path="$OPTARG"
            ;;
        b)
            IFS=',' read -ra blacklist <<< "$OPTARG"
            ;;
        H)
            include_hidden=true
            ;;
        *)
            usage
            ;;
    esac
done

find_command=(find "$start_path" -type f)

# If not including hidden items, exclude any file whose path contains a hidden file or directory.
if [ "$include_hidden" = false ]; then
    find_command+=(-not -path "*/.*")
fi

# For each blacklisted directory, exclude any file whose path contains that directory.
for dir in "${blacklist[@]}"; do
    find_command+=(-not -path "*/$dir/*")
done

# Run the find command and pipe the results to fzf with multi-selection enabled.
selected_files=$( "${find_command[@]}" | fzf --multi --prompt="Select file(s) > " )

# Exit if no file is selected.
if [ -z "$selected_files" ]; then
    echo "No file selected. Exiting."
    exit 1
fi

# For each selected file, print its full path followed by its content.
IFS=$'\n'
for file in $selected_files; do
    echo "File \`$file\`:"
    echo '```'
    cat "$file"
    echo '```'
    echo
done
