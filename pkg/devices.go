package pkg

import (
	"fmt"

	"github.com/vapor-ware/synse-sdk/sdk"
	"github.com/vapor-ware/synse-sdk/sdk/output"
)

// stateVal is a value that is written to by the writeOk handler and
// read from via the readOk handler.
//
// NOTE: This is an extremely simple way of managing state and is not
// recommended for real plugins, as this one variable will be shared
// by all device instances which use these handlers. The default
// configuration for this plugin is to have only one instance of each
// device, which mitigates this issue. For an example of how to handle
// this with multiple instances, see the emulator plugin.
var stateVal string

var (
	// readOk successfully reads from `stateVal`.
	readOk = sdk.DeviceHandler{
		Name: "read.ok",
		Read: func(device *sdk.Device) ([]*output.Reading, error) {

			stateReading := output.State.MakeReading(stateVal)

			return []*output.Reading{
				stateReading,
			}, nil
		},
	}

	// writeOk successfully writes to `stateVal`.
	writeOk = sdk.DeviceHandler{
		Name: "write.ok",
		Write: func(device *sdk.Device, data *sdk.WriteData) error {
			stateVal = data.Action
			return nil
		},
	}

	// readErr always returns an error when read from.
	readErr = sdk.DeviceHandler{
		Name: "read.error",
		Read: func(device *sdk.Device) ([]*output.Reading, error) {
			return nil, fmt.Errorf("some kind of read error happened -- sorry")
		},
	}

	// writeErr always returns an error when written to.
	writeErr = sdk.DeviceHandler{
		Name: "write.error",
		Write: func(device *sdk.Device, data *sdk.WriteData) error {
			return fmt.Errorf("some kind of write error happened -- sorry")
		},
	}
)
