#!/usr/bin/env bash

set -euo pipefail

# TODO: use `go list -f {{.Dir}}`
PKG=golang.org/x/tools
ROOT=/Users/cvieth/xgo/src/golang.org/x/tools

git mv "$ROOT/internal" "$ROOT/xint"
git mv "$ROOT/gopls/internal" "$ROOT/gopls/xint"

grep_flags=(
    --recursive
    --include='*.go'
    --files-with-matches
    --null
    --fixed-strings
)
grep "${grep_flags[@]}" 'golang.org/x/tools/internal' "$ROOT" |
    xargs -0 -- sed -i 's/golang.org\/x\/tools\/internal\//golang.org\/x\/tools\/xint\//g'

grep "${grep_flags[@]}" 'golang.org/x/tools/gopls/internal' "$ROOT" |
    xargs -0 -- sed -i 's/golang.org\/x\/tools\/gopls\/internal\//golang.org\/x\/tools\/gopls\/xint\//g'

GOBIN="$(mktemp -d)"
trap 'rm -rf $GOBIN' ERR

GOBIN="$GOBIN" go install "$PKG/..."
rm -r "$GOBIN"
