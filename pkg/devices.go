package pkg

import (
	"fmt"

	"github.com/vapor-ware/synse-sdk/sdk"
)

// stateVal is a value that is written to by the writeOk handler and
// read from via the readOk handler.
var stateVal string

var (
	// readOk successfully reads from `stateVal`.
	readOk = sdk.DeviceHandler{
		Name: "read.ok",
		Read: func(device *sdk.Device) ([]*sdk.Reading, error) {
			stateReading, err := device.GetOutput("simple").MakeReading(stateVal)
			if err != nil {
				return nil, err
			}

			return []*sdk.Reading{
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
		Read: func(device *sdk.Device) ([]*sdk.Reading, error) {
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
