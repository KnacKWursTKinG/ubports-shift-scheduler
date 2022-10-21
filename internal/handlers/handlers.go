package handlers

import (
	"encoding/json"
	"log"
	"time"

	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
	"gitlab.com/knackwurstking/shift-scheduler/internal/db"

	"github.com/nanu-c/qml-go"
)

type watchQueueData struct {
	object qml.Object
	year   int
	month  int
}

// handler shifts, notes
type MonthHandler struct {
	ctx *ctxobject.CtxObject
	db  *db.SQLiteDateBase // can be <nil>

	monthData []ctxobject.DayData // template data

	watchQueue map[int]*watchQueueData
}

func (mh *MonthHandler) UpdateShift(year, month, day int, shift string) {
	// check shift
	if mh.ctx.ShiftHandler.GetShift(year, month, day) == shift {
		id := db.GetID(year, month, day)
		err := mh.db.RemoveShift(id)
		if err != nil {
			log.Printf("[ERROR] remove shift for id=%d: %s", id, err.Error())
		}
	} else {
		err := mh.db.SetShift(db.GetID(year, month, day), shift)
		if err != nil {
			log.Printf("[ERROR] %d-%d-%d: update shift failed: %s\n", year, month, day, err.Error())
		}
	}
}

func (mh *MonthHandler) UpdateNotes(year, month, day int, notes string) {
	if notes != "" {
		err := mh.db.SetNotes(db.GetID(year, month, day), notes)
		if err != nil {
			log.Printf("[ERROR] %d-%d-%d: update notes failed: %s\n", year, month, day, err.Error())
		}
	} else {
		// remove notes from database
		err := mh.db.RemoveNotes(db.GetID(year, month, day))
		if err != nil {
			log.Printf("[ERROR] %d-%d-%d: remove notes failed: %s\n", year, month, day, err.Error())
		}
	}
}

func (mh *MonthHandler) Get(obj qml.Object, year, month, day int) {
	go func(date ctxobject.Date) {
		var shift string
		var notes string

		shift = mh.db.GetShift(db.GetID(date.Year, date.Month, date.Day))
		if shift == "" {
			shift = mh.ctx.ShiftHandler.GetShift(date.Year, date.Month, date.Day)
		}
		notes = mh.db.GetNotes(db.GetID(date.Year, date.Month, date.Day))

		data, err := json.Marshal(
			ctxobject.NewDayData(
				date,
				mh.ctx.ShiftHandler.ShiftsConfig.Get(shift),
				notes,
			),
		)
		if err != nil {
			log.Println("[ERROR] marshal json day data failed:", err.Error())
		} else {
			obj.Set("jDData", string(data))
		}
	}(ctxobject.NewDate(year, month, day))
}

// returns a JSON string
func (mh *MonthHandler) GetMonth(obj qml.Object, year, month int) string {
	data, err := json.Marshal(mh.monthData)
	if err != nil {
		log.Println("[ERROR] marshal month matrix data to json failed:", err.Error())
		return string(data)
	}

	go func(obj qml.Object, year, month int) {
		monthData := make([]ctxobject.DayData, 42)
		copy(monthData, mh.monthData)

		startDay := int(time.Date(year, time.Month(month), 1, 0, 0, 0, 0, time.Local).Weekday()) // month startDate date == 1

		// get data ...
		for idx := range monthData {
			date := time.Date(year, time.Month(month), idx+1-startDay, 0, 0, 0, 0, time.Local)
			cYear := date.Year()
			cMonth := int(date.Month())
			cDay := date.Day()

			// get shift and notes from ctx.ShiftHandler and database
			var shift string
			var notes string

			if cMonth == month {
				shift = mh.db.GetShift(db.GetID(cYear, cMonth, cDay))
				if shift == "" {
					shift = mh.ctx.ShiftHandler.GetShift(cYear, cMonth, cDay)
				}
				notes = mh.db.GetNotes(db.GetID(cYear, cMonth, cDay))
			}

			monthData[idx] = ctxobject.NewDayData(
				ctxobject.NewDate(date.Year(), int(date.Month()), date.Day()),
				mh.ctx.ShiftHandler.ShiftsConfig.Get(shift),
				notes,
			)
		}

		// set data to (qml) obj.jsonData
		if data, err := json.Marshal(monthData); err != nil {
			log.Println("[ERROR] marshal json month data failed:", err.Error())
		} else {
			obj.Set("jMData", string(data))
		}
	}(obj, year, month)

	return string(data)
}

func (mh *MonthHandler) WatchToday(index int, obj qml.Object, year, month int) {
	data, ok := mh.watchQueue[index]
	if !ok {
		mh.watchQueue[index] = &watchQueueData{
			object: obj,
			year:   year,
			month:  month,
		}
		data = mh.watchQueue[index]
	} else {
		data.object = obj
		data.year = year
		data.month = month
		return
	}

	go func(data *watchQueueData) {
		start := time.Now().Local()
		for {
			now := time.Now().Local()

			if now.Day() != start.Day() {
				start = now

				if data.month <= int(start.Month()+1) || data.month >= int(start.Month()-1) {
					//log.Println("[DEBUG] [internal/month/month.go] [WatchToday] update:", data)
					mh.GetMonth(data.object, data.year, data.month)
				}
			} else {
				nextDay := time.Date(start.Year(), start.Month(), start.Day()+1, 0, 0, 0, 0, start.Location()).Local()
				d := time.Second * time.Duration(nextDay.Unix()-now.Unix())
				//log.Println("[DEBUG] [internal/month/month.go] [WatchToday] sleep:", d, data)

				time.Sleep(d)
			}
		}
	}(data)
}

func NewMonthHandler(ctx *ctxobject.CtxObject, db *db.SQLiteDateBase) *MonthHandler {
	return &MonthHandler{
		ctx:        ctx,
		db:         db,
		monthData:  make([]ctxobject.DayData, 42),
		watchQueue: make(map[int]*watchQueueData),
	}
}
