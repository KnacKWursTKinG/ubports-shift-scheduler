package settings

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/pkg/db"
)

const (
	VERSION = 0
)

type Settings struct {
	Version     int    `json:"version"`
	ConfigPath  string `json:"-"`
	Shifts      Shifts `json:"shifts"`
	GridBorder  bool   `json:"grid-border"`
	ShiftBorder bool   `json:"shift-border"`
	Theme       string `json:"theme"`
}

func (s *Settings) SaveConfig() error { // <<-
	if s.ConfigPath == "" {
		return fmt.Errorf("config path missing")
	}

	file, err := os.Create(s.ConfigPath)
	if err != nil {
		if os.IsNotExist(err) {
			dirPath := filepath.Dir(s.ConfigPath)
			if err := os.MkdirAll(dirPath, 0700); err == nil {
				file, err = os.Create(s.ConfigPath)
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

	return json.NewEncoder(file).Encode(s)
} // ->>

func (s *Settings) LoadConfig() error { // <<-
	if s.ConfigPath == "" {
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
			s.GridBorder = true
			s.ShiftBorder = true
			s.Version = VERSION

			return nil
		}

		return err
	}

	err = json.Unmarshal(data, s)
	if err != nil {
		return err
	}

	return handleVersions(s)
} // ->>

func NewSettings(applicationName, configName string, db *db.SQLiteDateBase) (Settings, error) {
	s := Settings{
		ConfigPath: getConfigPath(applicationName, configName),
		Shifts:     NewShifts(db),
	}

	err := s.LoadConfig()

	return s, err
}

func getConfigPath(applicationName, configFile string) string { // <<-
	configPath, err := os.UserConfigDir()
	if err != nil {
		log.Println("error while getting the user config dir:", err.Error())
		return configFile
	}

	return filepath.Join(configPath, applicationName, configFile)
} // ->>

func handleVersions(s *Settings) (err error) { // <<-
	// NOTE: upgrade existing configuration here
	// ...

	//err = s.SaveConfig()
	return err
} // ->>
