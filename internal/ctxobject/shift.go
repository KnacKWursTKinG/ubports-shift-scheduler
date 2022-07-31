package ctxobject

type Shift struct {
	Name   string
	Color  string
	Size   int
	Hidden bool
}

// text size of 0 is the default
func NewShift(name, color string, size int, hidden bool) Shift {
	return Shift{
		Name:   name,
		Color:  color,
		Size:   size,
		Hidden: hidden,
	}
}
