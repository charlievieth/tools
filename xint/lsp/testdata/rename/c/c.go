package c

import "github.com/charlievieth/tools/xint/lsp/rename/b"

func _() {
	b.Hello() //@rename("Hello", "Goodbye")
}
