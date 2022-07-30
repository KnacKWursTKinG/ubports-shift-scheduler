package v0

type Shift struct {
	Name       string `json:"name"`
	ShiftColor string `json:"shift-color"`
	TextSize   int    `json:"text-size"`
	Hidden     bool   `json:"hidden"`
}

type StartDate struct {
	Year  int `json:"year"`
	Month int `json:"month"`
	Day   int `json:"day"`
}

type ShiftConfig struct {
	List []*Shift `json:"list"`
}

type Shifts struct {
	Start  StartDate   `json:"start"`
	Steps  []string    `json:"steps"`
	Config ShiftConfig `json:"config"`
}

type Settings struct {
	Version     int    `json:"version"`
	ConfigPath  string `json:"-"`
	Shifts      Shifts `json:"shifts"`
	GridBorder  bool   `json:"grid-border"`
	ShiftBorder bool   `json:"shift-border"`
	Theme       string `json:"theme"`
}
