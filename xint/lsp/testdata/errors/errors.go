package errors

import (
	"github.com/charlievieth/tools/xint/lsp/types"
)

func _() {
	bob.Bob() //@complete(".")
	types.b //@complete(" //", Bob_interface)
}
