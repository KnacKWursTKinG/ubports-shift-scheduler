package settings

type Shift struct {
	Name       string `json:"name"`
	ShiftColor string `json:"shift-color"`
	TextSize   int    `json:"text-size"`
	Hidden     bool   `json:"hidden"`
}

// textSize of 0 is the default
func NewShift(name, shiftColor string, textSize int, hidden bool) Shift {
	return Shift{
		Name:       name,
		ShiftColor: shiftColor,
		TextSize:   textSize,
		Hidden:     hidden,
	}
}
