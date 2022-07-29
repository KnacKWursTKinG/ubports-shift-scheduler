package ctxobject

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

type ShiftHandler struct {
	StartDate    StartDate    `json:"start"`
	Steps        []string     `json:"steps"`
	ShiftsConfig ShiftsConfig `json:"config"`
}
