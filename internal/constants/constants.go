package constants

import (
	"os"
	"strings"
)

const (
	APPLICATION_NAME = "shift-scheduler.knackwurstking"
	DATABASE_NAME    = "shifts.sql"
	CONFIG_NAME      = "config.json"
)

var (
	LANGUAGE = strings.Split(os.Getenv("LANG"), ".")[0]
)
