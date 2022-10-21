/*
 * Copyright (C) 2022  Udo Bauer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * shift-scheduler is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package main

import (
	"log"
	"os"
	"path/filepath"
	"strings"

	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
	"gitlab.com/knackwurstking/shift-scheduler/internal/db"
	"gitlab.com/knackwurstking/shift-scheduler/internal/month"
	"gitlab.com/knackwurstking/shift-scheduler/internal/tr"

	"github.com/nanu-c/qml-go"
)

const (
	APPLICATION_NAME = "shift-scheduler.knackwurstking"
	DATABASE_NAME    = "shifts.sql"
	CONFIG_NAME      = "config.json"
)

var (
	LANGUAGE = strings.Split(os.Getenv("LANG"), ".")[0]
)

func main() {
	err := qml.Run(run)
	if err != nil {
		log.Fatal(err)
	}
}

func run() error {
	engine := qml.NewEngine()
	component, err := engine.LoadFile("qml/Main.qml")
	if err != nil {
		return err
	}

	ctx := engine.Context()

	// initialize ctx object
	ctxObject, err := ctxobject.NewCtxObject(APPLICATION_NAME, CONFIG_NAME)
	if err != nil {
		log.Println("initialize settings failed:", err.Error())
	}

	// get database path
	var databasePath string
	homeDir, err := os.UserHomeDir()
	if err == nil {
		databasePath = filepath.Join(
			homeDir, ".local", "share", APPLICATION_NAME, DATABASE_NAME,
		)
	}

	// initialize database (sqlite3)
	sqlDB, err := db.NewSQLiteDataBase(databasePath)
	if err != nil {
		log.Println("initialize database failed:", err.Error())
		log.Println(databasePath)
	}
	defer sqlDB.Close()

	// set context (qml)
	ctx.SetVar("tr", tr.NewTr(LANGUAGE))
	ctx.SetVar("ctxo", ctxObject)
	ctx.SetVar("mh", month.NewMonthHandler(ctxObject, sqlDB))

	win := component.CreateWindow(nil)
	win.Show()
	win.Wait()

	return nil
}
