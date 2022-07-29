package ctxobject

import (
	"encoding/json"
	"log"
	"time"
)

type StartDate struct {
	Year  int
	Month int
	Day   int
}

func NewStartDate(year, month, day int) StartDate {
	return StartDate{
		Year:  year,
		Month: month,
		Day:   day,
	}
}

// shifts and shifts configuration
type ShiftHandler struct {
	StartDate    StartDate    `json:"start"`
	Steps        []string     `json:"steps"`
	ShiftsConfig ShiftsConfig `json:"config"`
}

func (sh *ShiftHandler) QmlGetSteps() string { // <<-
	data, _ := json.Marshal(sh.Steps)
	return string(data)
} // ->>

func (sh *ShiftHandler) QmlSetSteps(steps string) error { // <<-
	if err := json.Unmarshal([]byte(steps), &sh.Steps); err != nil {
		log.Println("set steps unmarshal:", err)

		return err
	}

	return nil
} // ->>

func (sh *ShiftHandler) SetStart(year, month, day int) { // <<-
	sh.StartDate = NewStartDate(year, month, day)
} // ->>

func (sh *ShiftHandler) GetShift(year, month, day int) (text string) { // <<-
	startT := int(time.Date(
		sh.StartDate.Year, time.Month(sh.StartDate.Month), sh.StartDate.Day,
		0, 0, 0, 0, time.UTC,
	).Unix())

	endT := int(time.Date(
		year, time.Month(month), day,
		0, 0, 0, 0, time.UTC,
	).Unix())

	steps := sh.Steps
	stepsL := len(steps)
	if stepsL == 0 {
		return text
	}

	if endT < startT {
		dt := int(startT - endT)
		d := int(dt / (60 * 60 * 24))

		idx := stepsL - (d % stepsL)
		if idx == stepsL {
			idx = 0
		}

		if stepsL >= idx {
			text = steps[idx]
		}
	} else {
		dt := int(endT - startT)
		d := int(dt / (60 * 60 * 24))

		idx := d % stepsL

		if stepsL >= idx {
			text = steps[idx]
		}
	}

	return text
} // ->>

func NewShiftHandler() ShiftHandler {
	return ShiftHandler{
		Steps:        make([]string, 0),
		ShiftsConfig: NewShiftsConfig(),
	}
}
