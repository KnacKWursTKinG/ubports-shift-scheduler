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

func (mh *MonthHandler) Get(obj qml.Object, date ctxobject.Date) {
	var shift string
	var notes string

	shift = mh.db.GetShift(mh.db.BuildID(date.Year, date.Month, date.Day))
	if shift == "" {
		shift = mh.ctx.ShiftHandler.GetShift(date.Year, date.Month, date.Day)
	}
	notes = mh.db.GetNotes(mh.db.BuildID(date.Year, date.Month, date.Day))

	obj.Set("dayData", NewDayData(
		date,
		*mh.ctx.ShiftHandler.ShiftsConfig.Get(shift),
		notes,
	))
}

// returns a JSON string
func (mh *MonthHandler) GetMonth(obj qml.Object, year, month int) string {
	data, err := json.Marshal(mh.monthData)
	if err != nil {
		log.Println("error while marshal month matrix to json:", err.Error())
		return string(data)
	}

	go func() {
		monthData := mh.monthData
		startDay := int(time.Date(year, time.Month(month), 1, 0, 0, 0, 0, time.UTC).Weekday()) // month startDate date == 1

		// get data ...
		for idx := range monthData {
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

			monthData[idx] = NewDayData(
				ctxobject.NewDate(date.Year(), int(date.Month()), date.Day()),
				*mh.ctx.ShiftHandler.ShiftsConfig.Get(shift),
				notes,
			)
		}

		// set data to (qml) obj.jsonData
		if data, err := json.Marshal(monthData); err != nil {
			log.Println("error while marshal json month data:", err.Error())
		} else {
			obj.Set("jsonData", string(data))
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
