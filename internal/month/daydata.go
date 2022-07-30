package month

import (
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
)

type DayData struct {
	Date  ctxobject.Date  `json:"Date"`
	Today bool            `json:"Today"`
	Shift ctxobject.Shift `json:"Shift"`
	Notes string          `json:"Notes"`
}

func NewDayData(date ctxobject.Date, shiftConfig *ctxobject.Shift, notes string) DayData {
	return DayData{
		Date: date,
		Today: func() bool {
			today := time.Now()
			return today.Year() == date.Year &&
				today.Month() == time.Month(date.Month) &&
				today.Day() == date.Day
		}(),
		Shift: *shiftConfig,
		Notes: notes,
	}
}
