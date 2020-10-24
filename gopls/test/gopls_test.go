// Copyright 2019 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package gopls_test

import (
	"os"
	"testing"

	"github.com/charlievieth/tools/gopls/xint/hooks"
	cmdtest "github.com/charlievieth/tools/xint/lsp/cmd/test"
	"github.com/charlievieth/tools/xint/lsp/source"
	"github.com/charlievieth/tools/xint/lsp/tests"
	"github.com/charlievieth/tools/xint/testenv"
)

func TestMain(m *testing.M) {
	testenv.ExitIfSmallMachine()
	os.Exit(m.Run())
}

func TestCommandLine(t *testing.T) {
	cmdtest.TestCommandLine(t, "../../internal/lsp/testdata", commandLineOptions)
}

func commandLineOptions(options *source.Options) {
	options.Staticcheck = true
	options.GoDiff = false
	tests.DefaultOptions(options)
	hooks.Options(options)
}
