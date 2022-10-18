# CHANGELOG

## [v1.3.0] - Work in progress

- [ ] changed shift rhythm edit in settings
- [x] page stack handling, don't clear the `pageStack` while entering the settings page (or leaving)
- [x] some clean up (qml)
- [x] Fix the subtitle.text for settings start date

## [v1.2.0] - 2022-09-21

### Added

- do an update at 12:00AM (this will update the qml today highlighting)

### Fixed

- undo the button moved above the divider from the last update (that was a mistake)

## [v1.1.1] - 2022-09-18

### Changed

- moved the `Day` dialog "update" button above the `Divider` ~(the button only handles the shift change)~

### Fixed

- Dialog: DatePicker highlight colors (these white on white stuff in dark-mode/SuruDark)

## [v1.1.0] - 2022-08-10

### Added

- performance improvements while swiping left and right

### Changed

- dialog buttons not conform to [HIG](https://docs.ubports.com/en/latest/humanguide/app-layout/dialogs.html)
