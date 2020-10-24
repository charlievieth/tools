package nodisk

import (
	"github.com/charlievieth/tools/xint/lsp/foo"
)

func _() {
	foo.Foo() //@complete("F", Foo, IntFoo, StructFoo)
}
