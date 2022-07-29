package month

import (
	"encoding/json"
	"log"
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
	"gitlab.com/knackwurstking/shift-scheduler/internal/db"

	"github.com/nanu-c/qml-go"
)

// handler shifts, notes
type MonthHandler struct {
	ctx *ctxobject.CtxObject
	db  *db.SQLiteDateBase // can be <nil>

	//matrix [][]DayData // initial data for the MonthGrid (qml)
	monthData []DayData // template data
}

// returns a JSON string
func (mh *MonthHandler) GetMonth(grid qml.Object, year, month int) string {
	data, err := json.Marshal(mh.monthData)
	if err != nil {
		log.Println("error while marshal month matrix to json:", err.Error())
		return string(data)
	}

	go func() {
		monthData := mh.monthData
		startDay := time.Date(year, time.Month(month), 1, 0, 0, 0, 0, time.UTC).Day() // month startDate date == 1

		// get data ...
		for idx := range monthData {
			// TODO: can i realy calculate this like in javascript?
			date := time.Date(year, time.Month(month), idx+1-startDay, 0, 0, 0, 0, time.UTC)
			cYear := date.Year()
			cMonth := int(date.Month())
			cDay := date.Day()

			// get shift and notes from ctx.ShiftHandler and database
			var shift string
			var notes string

			if cMonth == month {
				shift = mh.db.GetShift(mh.db.BuildID(cYear, cMonth, cDay))
				if shift == "" {
					shift = mh.ctx.ShiftHandler.GetShift(cYear, cMonth, cDay)
				}
				notes = mh.db.GetNotes(mh.db.BuildID(cYear, cMonth, cDay))
			}

			monthData[idx] = NewDayData(int(date.Weekday()), date.Day(), shift, notes)
		}

		// set data to (qml) obj.jsonData
		if data, err := json.Marshal(monthData); err != nil {
			log.Println("error while marshal json month data:", err.Error())
		} else {
			grid.Set("jsonData", string(data))
		}
	}()

	return string(data)
}

func NewMonthHandler(ctx *ctxobject.CtxObject, db *db.SQLiteDateBase) *MonthHandler {
	return &MonthHandler{
		ctx:       ctx,
		db:        db,
		monthData: make([]DayData, 42),
	}
}
