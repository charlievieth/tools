#!/usr/bin/env bash

set -euo pipefail

ROOT="$(dirname "$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)")"

FROM=golang.org/x/tools
PKG=github.com/charlievieth/tools
TO="$PKG"

GREP_FLAGS=(
    --recursive
    --exclude-dir 'scripts'
    --exclude-dir '.git'
    --files-with-matches
    --null
    --fixed-strings
)

escape_import_path() {
    sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$1"
}

fix_import_paths() {
    local from="$1"
    local to="$2"

    local replace
    replace="s/$(escape_import_path "$from")/$(escape_import_path "$to")/g"

    if ! grep "${GREP_FLAGS[@]}" "$from" "$ROOT" | xargs -0 -- sed -i "$replace"; then
        echo "error: fix_import_paths" >&2
        return 1
    fi
    return 0
}

move_package() {
    local from="$1"
    local to="$2"

    local from_replace to_replace
    replace="s/$(escape_import_path "$from")/$(escape_import_path "$to")/g"

    if ! grep "${GREP_FLAGS[@]}" "$from" "$ROOT" | xargs -0 -- sed -i "$replace"; then
        echo "error: move_package" >&2
        return 1
    fi
}

git fetch --all
LATEST="$(git rev-parse golang/master)"
BRANCH="golang-$(head -c 8 <<<"$LATEST")"

# WARN
if git branch | grep -F "$BRANCH"; then
    git branch -D "$BRANCH"
fi

git checkout -b "$BRANCH"
git reset --hard golang/master

PRUNE_DIRS=(
    'benchmark'
    'blog'
    'cmd'
    'container'
    'cover'
    'go'
    'godoc'
    'imports'
    'playground'
    'present'
    'refactor'
    'txtar'
)
git rm -r "${PRUNE_DIRS[@]}"
git rm codereview.cfg

git mv "$ROOT/internal" "$ROOT/xint"
move_package "$FROM/internal" "$TO/xint"

git mv "$ROOT/gopls/internal" "$ROOT/gopls/xint"
move_package "$FROM/gopls/internal" "$TO/gopls/xint"

fix_import_paths "$FROM/gopls" "$TO/gopls"

# re-sort imports post-rename
FIND_PRUNE_ARGS=(
    -type d -name 'vendor' -o
    -type d -name 'testdata' -o
    -type d -name '.git' -o
    -type f -name '*.pb.go'
)
find "$ROOT" \( "${FIND_PRUNE_ARGS[@]}" \) -prune -o -type f -name '*.go' -print0 |
    xargs -0 -- goimports -w

# TODO:
#  1. go mod tidy
#  2. git add / commit
#  3. git push
#  4. git merge
