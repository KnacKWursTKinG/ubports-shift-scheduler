package month

import (
	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
	"gitlab.com/knackwurstking/shift-scheduler/internal/db"
)

// handler shifts, notes
type MonthHandler struct {
	ctx *ctxobject.CtxObject
	db  *db.SQLiteDateBase // can be <nil>
}

func NewMonthHandler(ctx *ctxobject.CtxObject, db *db.SQLiteDateBase) *MonthHandler {
	return &MonthHandler{
		ctx: ctx,
		db:  db,
	}
}
