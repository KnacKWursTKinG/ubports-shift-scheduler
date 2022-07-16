package settings

type StartDate struct {
	Year  int `json:"year"`
	Month int `json:"month"`
	Day   int `json:"day"`
}

func NewStartDate(year, month, day int) StartDate {
	return StartDate{
		Year:  year,
		Month: month,
		Day:   day,
	}
}
