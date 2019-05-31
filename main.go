package main

import (
	log "github.com/sirupsen/logrus"
	"github.com/vapor-ware/sandbox-plugin/pkg"
	"github.com/vapor-ware/synse-sdk/sdk"
)

const (
	pluginName       = "sandbox plugin"
	pluginMaintainer = "vaporio"
	pluginDesc       = "a plugin for quick iteration and testing of use cases"
	pluginVcs        = "github.com/vapor-ware/sandbox-plugin"
)

func main() {
	sdk.SetPluginInfo(
		pluginName,
		pluginMaintainer,
		pluginDesc,
		pluginVcs,
	)

	plugin := pkg.MakePlugin()

	// Run the plugin
	if err := plugin.Run(); err != nil {
		log.Fatal(err)
	}
}
