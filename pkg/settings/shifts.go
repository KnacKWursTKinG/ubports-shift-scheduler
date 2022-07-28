package settings

import (
	"encoding/json"
	"log"
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/pkg/db"
)

type Shifts struct {
	Start  StartDate          `json:"start"`
	Steps  []string           `json:"steps"`
	Config ShiftConfig        `json:"config"`
	DB     *db.SQLiteDateBase `json:"-"` // NOTE: coul'd be nil
}

func (s *Shifts) QmlGetSteps() string { // <<-
	data, _ := json.Marshal(s.Steps)
	return string(data)
} // ->>

func (s *Shifts) QmlSetSteps(steps string) error { // <<-
	if err := json.Unmarshal([]byte(steps), &s.Steps); err != nil {
		log.Println("set steps unmarshal:", err)

		return err
	}

	return nil
} // ->>

func (s *Shifts) SetStart(year, month, day int) { // <<-
	s.Start = NewStartDate(year, month, day)
} // ->>

func (s *Shifts) GetShift(year, month, day int) (text string) { // <<-
	startT := int(time.Date(
		s.Start.Year, time.Month(s.Start.Month), s.Start.Day,
		0, 0, 0, 0, time.UTC,
	).Unix())

	endT := int(time.Date(
		year, time.Month(month), day,
		0, 0, 0, 0, time.UTC,
	).Unix())

	steps := s.Steps
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

func NewShifts(db *db.SQLiteDateBase) Shifts {
	return Shifts{
		Steps:  make([]string, 0),
		Config: NewShiftConfig(),
		DB:     db,
	}
}
