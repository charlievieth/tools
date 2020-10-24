package a

import (
	_ "github.com/charlievieth/tools/xint/lsp/circular/triple/b" //@diag("_ \"github.com/charlievieth/tools/xint/lsp/circular/triple/b\"", "compiler", "import cycle not allowed", "error")
)
