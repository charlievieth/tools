// Copyright 2019 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// The gopls command is an LSP server for Go.
// The Language Server Protocol allows any text editor
// to be extended with IDE-like features;
// see https://langserver.org/ for details.
//
// See https://github.com/golang/tools/tree/master/gopls
// for the most up-to-date information on the gopls status.
package main // import "github.com/charlievieth/tools/gopls"

import (
	"context"
	"os"

	"github.com/charlievieth/tools/gopls/xint/hooks"
	"github.com/charlievieth/tools/xint/lsp/cmd"
	"github.com/charlievieth/tools/xint/tool"
)

func main() {
	ctx := context.Background()
	tool.Main(ctx, cmd.New("gopls", "", nil, hooks.Options), os.Args[1:])
}
