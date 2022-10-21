package ctxobject

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/internal/constants"
	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject/configs/v0"
)

const CONFIG_VERSION = 1

var ErrorLogger = constants.ErrorLogger

// configuration
type CtxObject struct {
	Version         int
	ApplicationName string `json:"-"`
	ConfigName      string `json:"-"`
	GridBorder      bool
	ShiftBorder     bool
	Theme           string
	ShiftHandler    ShiftHandler
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

			ctx.ShiftHandler.StartDate = NewDate(
				d.Year(), int(d.Month()), d.Day(),
			)

			ctx.ShiftHandler.Steps = make([]string, 0)
			ctx.ShiftHandler.ShiftsConfig.List = make([]*Shift, 0)
			ctx.GridBorder = true
			ctx.ShiftBorder = true
			ctx.Version = CONFIG_VERSION

			return ctx.HandleConfigVersion()
		}

		return err
	}

	err = json.Unmarshal(data, ctx)
	if err != nil {
		return err
	}

	if ctx.Version < CONFIG_VERSION {
		return ctx.HandleConfigVersion()
	}

	return nil
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
					ErrorLogger.Println("saving config failed:", err)
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
		ErrorLogger.Println("get configuration path:", err.Error())
		return ctx.ConfigName
	}

	return filepath.Join(configPath, ctx.ApplicationName, ctx.ConfigName)
}

func (ctx *CtxObject) HandleConfigVersion() (err error) {
	// NOTE: upgrade existing configuration here
	configPath := ctx.GetConfigPath()

	if ctx.Version == 0 {
		log.Printf("upgrade configuration from version 0 to %d\n", CONFIG_VERSION)
		var v0Config v0.Settings
		data, err := ioutil.ReadFile(configPath)
		if err == nil {
			err = json.Unmarshal(data, &v0Config)
			if err == nil {
				ctx.GridBorder = v0Config.GridBorder
				ctx.ShiftBorder = v0Config.ShiftBorder
				ctx.ShiftHandler.Steps = v0Config.Shifts.Steps

				ctx.ShiftHandler.StartDate = NewDate(
					v0Config.Shifts.Start.Year,
					v0Config.Shifts.Start.Month,
					v0Config.Shifts.Start.Day,
				)

				for _, v := range v0Config.Shifts.Config.List {
					ctx.ShiftHandler.ShiftsConfig.Append(
						v.Name, v.ShiftColor, v.TextSize, v.Hidden,
					)
				}
			}
		}
	}

	ctx.Version = CONFIG_VERSION
	return ctx.SaveConfig()
}

func NewCtxObject(applicationName, configName string) (*CtxObject, error) {
	ctx := CtxObject{
		ApplicationName: applicationName,
		ConfigName:      configName,
		ShiftHandler:    NewShiftHandler(),
	}

	return &ctx, ctx.LoadConfig()
}
