package ctxobject

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"time"
)

const CONFIG_VERSION = 0

// configuration
// TODO: missing from old Settings struct: shifts, SaveConfig
type CtxObject struct {
	Version         int    `json:"version"`
	ApplicationName string `json:"-"`
	ConfigName      string `json:"-"`
	GridBorder      bool   `json:"grid-border"`
	ShiftBorder     bool   `json:"grid-border"`
	Theme           string `json:"theme"`
}

func (ctx *CtxObject) LoadConfig() error {
	configPath := ctx.GetConfigPath()
	if configPath == "" {
		return fmt.Errorf("config path missing")
	}

	data, err := ioutil.ReadFile(s.ConfigPath)
	if err != nil {
		// if file not exists error: set defaults
		if os.IsNotExist(err) {
			d := time.Now()

			s.Shifts.Start = StartDate{
				Year:  d.Year(),
				Month: int(d.Month()),
				Day:   d.Day(),
			}

			s.Shifts.Steps = make([]string, 0)
			s.Shifts.Config.List = make([]*Shift, 0)
			ctx.GridBorder = true
			ctx.ShiftBorder = true
			ctx.Version = CONFIG_VERSION

			return nil
		}

		return err
	}

	err = json.Unmarshal(data, ctx)
	if err != nil {
		return err
	}

	return ctx.HandleConfigVersion()

	return nil
}

func (ctx *CtxObject) GetConfigPath() string {
	// TODO: ...

	return ""
}

func (ctx *CtxObject) HandleConfigVersion() (err error) {
	// NOTE: upgrade existing configuration here
	// ...

	//err = s.SaveConfig()
	return err
}

func NewCtxObject(applicationName, configName string) (*CtxObject, error) {
	ctx := CtxObject{
		ApplicationName: applicationName,
		ConfigName: configName,
	}

	return &ctx, ctx.LoadConfig()
}

