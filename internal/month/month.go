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

func (mh *MonthHandler) UpdateShift(year, month, day int, shift string) {
	// check shift
	if mh.ctx.ShiftHandler.GetShift(year, month, day) == shift {
		mh.db.RemoveShift(mh.db.BuildID(year, month, day))
	} else {
		err := mh.db.SetShift(mh.db.BuildID(year, month, day), shift)
		if err != nil {
			log.Printf("[%d-%d-%d] update shift failed: %s\n", year, month, day, err.Error())
		}
	}
}

func (mh *MonthHandler) UpdateNotes(year, month, day int, notes string) {
	if notes != "" {
		err := mh.db.SetNotes(mh.db.BuildID(year, month, day), notes)
		if err != nil {
			log.Printf("[%d-%d-%d] update notes failed: %s\n", year, month, day, err.Error())
		}
	} else {
		// remove notes from database
		err := mh.db.RemoveNotes(mh.db.BuildID(year, month, day))
		if err != nil {
			log.Printf("[%d-%d-%d] remove notes failed: %s\n", year, month, day, err.Error())
		}
	}
}

func (mh *MonthHandler) Get(obj qml.Object, year, month, day int) {
	go func(date ctxobject.Date) {
		var shift string
		var notes string

		shift = mh.db.GetShift(mh.db.BuildID(date.Year, date.Month, date.Day))
		if shift == "" {
			shift = mh.ctx.ShiftHandler.GetShift(date.Year, date.Month, date.Day)
		}
		notes = mh.db.GetNotes(mh.db.BuildID(date.Year, date.Month, date.Day))

		dayData := NewDayData(
			date,
			mh.ctx.ShiftHandler.ShiftsConfig.Get(shift),
			notes,
		)

		if data, err := json.Marshal(dayData); err != nil {
			log.Println("error while marshal json day data:", err.Error())
		} else {
			obj.Set("jsonDayData", string(data))
		}
	}(ctxobject.NewDate(year, month, day))
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
				mh.ctx.ShiftHandler.ShiftsConfig.Get(shift),
				notes,
			)
		}

		// set data to (qml) obj.jsonData
		if data, err := json.Marshal(monthData); err != nil {
			log.Println("error while marshal json month data:", err.Error())
		} else {
			obj.Set("jsonMonthData", string(data))
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
