#!/usr/bin/env bash

set -euo pipefail

ROOT="$(dirname $(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd))"

FROM=golang.org/x/tools
TO=github.com/charlievieth/tools

FROM_REPLACE="$(sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$FROM")"
TO_REPLACE="$(sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$TO")"

grep_flags=(
    --recursive
    --exclude-dir 'scripts'
    --exclude-dir '.git'
    --files-with-matches
    --null
    --fixed-strings
)
grep "${grep_flags[@]}" "$FROM" "$ROOT" |
    xargs -0 -- sed -i "s/${FROM_REPLACE}/${TO_REPLACE}/g"
