package month

type DayData struct {
	Day   int // 0-6
	Date  int
	Shift string
	Notes string
}

func NewDayData(day, date int, shift, notes string) DayData {
	return DayData{
		Day:   day,
		Date:  date,
		Shift: shift,
		Notes: notes,
	}
}
