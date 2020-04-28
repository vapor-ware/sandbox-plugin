package main

import (
	log "github.com/sirupsen/logrus"
	"github.com/vapor-ware/sandbox-plugin/pkg"
)

const (
	pluginName       = "sandbox plugin"
	pluginMaintainer = "vaporio"
	pluginDesc       = "a plugin for quick iteration and testing of use cases"
	pluginVcs        = "github.com/vapor-ware/sandbox-plugin"
)

func main() {
	plugin := pkg.MakePlugin()

	// Run the plugin
	if err := plugin.Run(); err != nil {
		log.Fatal(err)
	}
}
