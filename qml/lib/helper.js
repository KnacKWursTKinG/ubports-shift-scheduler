function getShift(year, month, day) {
  const customShift = db.getShift(db.buildID(year, month, day))
  if (!customShift)
    return settings.shifts.getShift(year, month, day) || ""

  return customShift || ""
}
