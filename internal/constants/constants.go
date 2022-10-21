package constants

import (
	"log"
	"os"
	"strings"
)

const (
	APPLICATION_NAME = "shift-scheduler.knackwurstking"
	DATABASE_NAME    = "shifts.sql"
	CONFIG_NAME      = "config.json"
)

var (
	LANGUAGE    = strings.Split(os.Getenv("LANG"), ".")[0]
	ErrorLogger *log.Logger
)

func init() {
	log.SetFlags(log.Lshortfile | log.LstdFlags)
	ErrorLogger = log.New(os.Stderr, "[ERROR] ", log.Lshortfile|log.LstdFlags)
}
