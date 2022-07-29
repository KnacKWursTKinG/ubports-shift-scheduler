package ctxobject

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"time"
)

const CONFIG_VERSION = 0

// configuration
type CtxObject struct {
	Version         int          `json:"version"`
	ApplicationName string       `json:"-"`
	ConfigName      string       `json:"-"`
	GridBorder      bool         `json:"grid-border"`
	ShiftBorder     bool         `json:"shift-border"`
	Theme           string       `json:"theme"`
	ShiftHandler    ShiftHandler `json:"shifts"`
}

func (ctx *CtxObject) LoadConfig() error {
	configPath := ctx.GetConfigPath()
	if configPath == "" {
		return fmt.Errorf("config path missing")
	}

	data, err := ioutil.ReadFile(configPath)
	if err != nil {
		// if file not exists error: set defaults
		if os.IsNotExist(err) {
			d := time.Now()

			ctx.ShiftHandler.StartDate = NewStartDate(
				d.Year(), int(d.Month()), d.Day(),
			)

			ctx.ShiftHandler.Steps = make([]string, 0)
			ctx.ShiftHandler.ShiftsConfig.List = make([]*Shift, 0)
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
}

func (ctx *CtxObject) SaveConfig() error {
	configPath := ctx.GetConfigPath()
	if configPath == "" {
		return fmt.Errorf("config path missing")
	}

	file, err := os.Create(configPath)
	if err != nil {
		if os.IsNotExist(err) {
			dirPath := filepath.Dir(configPath)
			if err := os.MkdirAll(dirPath, 0700); err == nil {
				file, err = os.Create(configPath)
				if err != nil {
					log.Println(err)
					return err
				}
			}
		} else {
			return err
		}
	}
	defer file.Close()

	return json.NewEncoder(file).Encode(ctx)
}

func (ctx *CtxObject) GetConfigPath() string {
	configPath, err := os.UserConfigDir()
	if err != nil {
		log.Println("error while getting the user config dir:", err.Error())
		return ctx.ConfigName
	}

	return filepath.Join(configPath, ctx.ApplicationName, ctx.ConfigName)
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
		ConfigName:      configName,
		ShiftHandler:    NewShiftHandler(),
	}

	return &ctx, ctx.LoadConfig()
}
