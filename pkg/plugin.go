package pkg

import (
	log "github.com/Sirupsen/logrus"
	"github.com/vapor-ware/synse-sdk/sdk"
)

// MakePlugin creates a new instance of the Sandbox Plugin.
func MakePlugin() *sdk.Plugin {
	plugin := sdk.NewPlugin()

	// Register the output types
	if err := plugin.RegisterOutputTypes(
		&simpleOutput,
	); err != nil {
		log.Fatal(err)
	}

	// Register device handlers
	plugin.RegisterDeviceHandlers(
		&readOk,
		&readErr,
		&writeOk,
		&writeErr,
	)

	return plugin
}
