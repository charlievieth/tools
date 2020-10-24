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

    # local from_replace to_replace
    # from_replace="$(sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$from")"
    # to_replace="$(sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$to")"

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
    from_replace="$(escape_import_path "$from")"
    to_replace="$(escape_import_path "$to")"
    # from_replace="$(sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$from")"
    # to_replace="$(sed -e 's/\./\\\./g' -e 's/\//\\\//g' <<<"$to")"

    if ! grep "${GREP_FLAGS[@]}" "$from" "$ROOT" |
        xargs -0 -- sed -i "s/${from_replace}/${to_replace}/g"; then
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

git rm -r benchmark blog cmd container cover go godoc imports playground present refactor txtar
git rm codereview.cfg

git mv "$ROOT/internal" "$ROOT/xint"
move_package "$FROM/internal" "$TO/xint"

git mv "$ROOT/gopls/internal" "$ROOT/gopls/xint"
move_package "$FROM/gopls/internal" "$TO/gopls/xint"

fix_import_paths "$FROM/gopls" "$TO/gopls"

# GOBIN="$(mktemp -d)"
# trap 'rm -rf $GOBIN' ERR

# GOBIN="$GOBIN" go install "$PKG/..."
# rm -r "$GOBIN"

# export_internal_packages() {
#     git mv "$ROOT/internal" "$ROOT/xint"
#     git mv "$ROOT/gopls/internal" "$ROOT/gopls/xint"

#     grep_flags=(
#         --recursive
#         --include='*.go'
#         --files-with-matches
#         --null
#         --fixed-strings
#     )
#     grep "${grep_flags[@]}" 'golang.org/x/tools/internal' "$ROOT" |
#         xargs -0 -- sed -i 's/golang.org\/x\/tools\/internal\//golang.org\/x\/tools\/xint\//g'

#     grep "${grep_flags[@]}" 'golang.org/x/tools/gopls/internal' "$ROOT" |
#         xargs -0 -- sed -i 's/golang.org\/x\/tools\/gopls\/internal\//golang.org\/x\/tools\/gopls\/xint\//g'

# }
