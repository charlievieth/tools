package danglingstmt

import "github.com/charlievieth/tools/xint/lsp/foo"

func _() {
	foo. //@rank(" //", Foo)
	var _ = []string{foo.} //@rank("}", Foo)
}
