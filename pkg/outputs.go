package pkg

import (
	"github.com/vapor-ware/synse-sdk/sdk/output"
)

var (
	// simpleOutput is a simple output type handler that doesn't
	// define much of anything.
	simpleOutput = output.Output{
		Name: "simple",
	}
)
