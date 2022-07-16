package settings

type ShiftConfig struct {
	List []*Shift `json:"list"`
}

func (sc *ShiftConfig) Count() int { // <<-
	return len(sc.List)
} // ->>

func (sc *ShiftConfig) Exists(name string) bool { // <<-
	for _, shift := range sc.List {
		if shift.Name == name {
			return true
		}
	}

	return false
} // ->>

func (sc *ShiftConfig) GetNamePerIndex(index int) string { // <<-
	if index >= sc.Count() {
		return ""
	}

	return sc.List[index].Name
} // ->>

func (sc *ShiftConfig) GetIndex(index int) *Shift { // <<-
	if sc.Count() <= index {
		return nil
	}

	return sc.List[index]
} // ->>

func (sc *ShiftConfig) Get(name string) *Shift { // <<-
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
func (sc *ShiftConfig) Append(name, shiftColor string, textSize int, hidden bool) { // <<-
	// make sure name is unique
	for _, v := range sc.List {
		if v.Name == name {
			sc.Set(name, name, shiftColor, textSize, hidden)
			return
		}
	}

	shift := NewShift(name, shiftColor, textSize, hidden)
	sc.List = append(sc.List, &shift)
} // ->>

// add or update a shift
func (sc *ShiftConfig) Set(origin string, name, shiftColor string, textSize int, hidden bool) { // <<-
	for x := 0; x < len(sc.List); x++ {
		if sc.List[x].Name == origin {
			sc.List[x] = &Shift{
				Name:       name,
				ShiftColor: shiftColor,
				TextSize:   textSize,
				Hidden:     hidden,
			}

			return
		}
	}

	sc.Append(name, shiftColor, textSize, hidden)
} // ->>

func (sc *ShiftConfig) Remove(name string) { // <<-
	var newList []*Shift
	for x := 0; x < sc.Count(); x++ {
		if sc.List[x].Name != name {
			newList = append(newList, sc.List[x])
		}
	}
	sc.List = newList
} // ->>

func NewShiftConfig(shifts ...*Shift) ShiftConfig {
	return ShiftConfig{
		List: shifts,
	}
}
