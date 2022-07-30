package month

import (
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
)

// TODO: add data struct (like StartDate)
type DayData struct {
	Date  ctxobject.Date  `json:"date"`
	Today bool            `json:"today"`
	Shift ctxobject.Shift `json:"shift"`
	Notes string          `json:"notes"`
}

func NewDayData(date ctxobject.Date, shiftConfig ctxobject.Shift, notes string) DayData {
	return DayData{
		Date: date,
		Today: func() bool {
			today := time.Now()
			return today.Year() == date.Year &&
				today.Month() == time.Month(date.Month) &&
				today.Day() == date.Day
		}(),
		Shift: shiftConfig,
		Notes: notes,
	}
}
