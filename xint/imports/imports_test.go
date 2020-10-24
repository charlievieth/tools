package imports

import (
	"os"
	"testing"

	"github.com/charlievieth/tools/xint/testenv"
)

func TestMain(m *testing.M) {
	testenv.ExitIfSmallMachine()
	os.Exit(m.Run())
}
