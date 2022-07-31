package ctxobject

type Date struct {
	Year  int
	Month int
	Day   int
}

func NewDate(year, month, day int) Date {
	return Date{
		Year:  year,
		Month: month,
		Day:   day,
	}
}
