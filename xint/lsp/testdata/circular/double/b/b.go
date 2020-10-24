package b

import (
	_ "github.com/charlievieth/tools/xint/lsp/circular/double/one" //@diag("_ \"github.com/charlievieth/tools/xint/lsp/circular/double/one\"", "compiler", "import cycle not allowed", "error"),diag("\"github.com/charlievieth/tools/xint/lsp/circular/double/one\"", "compiler", "could not import github.com/charlievieth/tools/xint/lsp/circular/double/one (no package for import github.com/charlievieth/tools/xint/lsp/circular/double/one)", "error")
)
