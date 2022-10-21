package ctxobject

import (
	"time"
)

type DayData struct {
	Date  Date   `json:"Date"`
	Today bool   `json:"Today"`
	Shift Shift  `json:"Shift"`
	Notes string `json:"Notes"`
}

func NewDayData(date Date, shiftConfig *Shift, notes string) DayData {
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
