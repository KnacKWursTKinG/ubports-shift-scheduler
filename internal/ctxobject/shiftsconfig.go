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

type ShiftsConfig struct {
	List []*Shift
}

func (sc *ShiftsConfig) Count() int { // <<-
	return len(sc.List)
} // ->>

func (sc *ShiftsConfig) Exists(name string) bool { // <<-
	for _, shift := range sc.List {
		if shift.Name == name {
			return true
		}
	}

	return false
} // ->>

func (sc *ShiftsConfig) GetNamePerIndex(index int) string { // <<-
	if index >= sc.Count() {
		return ""
	}

	return sc.List[index].Name
} // ->>

func (sc *ShiftsConfig) GetIndex(index int) *Shift { // <<-
	if sc.Count() <= index {
		return nil
	}

	return sc.List[index]
} // ->>

func (sc *ShiftsConfig) Get(name string) *Shift { // <<-
	if name == "" {
		shift := NewShift(name, "", 0, true)
		return &shift
	}

	for x := 0; x < len(sc.List); x++ {
		if sc.List[x].Name == name {
			return sc.List[x]
		}
	}

	sc.Append(name, "", 0, false)
	return sc.Get(name)
} // ->>

// add a shift (overwrite if shift already exists)
func (sc *ShiftsConfig) Append(name, color string, size int, hidden bool) { // <<-
	// make sure name is unique
	for _, v := range sc.List {
		if v.Name == name {
			sc.Set(name, name, color, size, hidden)
			return
		}
	}

	shift := NewShift(name, color, size, hidden)
	sc.List = append(sc.List, &shift)
} // ->>

// add or update a shift
func (sc *ShiftsConfig) Set(origin string, name, color string, size int, hidden bool) { // <<-
	for x := 0; x < len(sc.List); x++ {
		if sc.List[x].Name == origin {
			sc.List[x] = &Shift{
				Name:   name,
				Color:  color,
				Size:   size,
				Hidden: hidden,
			}

			return
		}
	}

	sc.Append(name, color, size, hidden)
} // ->>

func (sc *ShiftsConfig) Remove(name string) { // <<-
	var newList []*Shift
	for x := 0; x < sc.Count(); x++ {
		if sc.List[x].Name != name {
			newList = append(newList, sc.List[x])
		}
	}
	sc.List = newList
} // ->>

func NewShiftsConfig(shifts ...*Shift) ShiftsConfig {
	return ShiftsConfig{
		List: shifts,
	}
}
