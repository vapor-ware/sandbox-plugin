package pkg

import (
	log "github.com/sirupsen/logrus"
	"github.com/vapor-ware/synse-sdk/sdk"
)

// MakePlugin creates a new instance of the Sandbox Plugin.
func MakePlugin() *sdk.Plugin {
	plugin, err := sdk.NewPlugin()
	if err != nil {
		log.Fatal(err)
	}

	// Register device handlers
	err = plugin.RegisterDeviceHandlers(
		&readOk,
		&readErr,
		&writeOk,
		&writeErr,
	)
	if err != nil {
		log.Fatal(err)
	}

	return plugin
}
