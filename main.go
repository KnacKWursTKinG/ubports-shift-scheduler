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

	"gitlab.com/knackwurstking/shift-scheduler/internal/constants"
	"gitlab.com/knackwurstking/shift-scheduler/internal/ctxobject"
	"gitlab.com/knackwurstking/shift-scheduler/internal/db"
	"gitlab.com/knackwurstking/shift-scheduler/internal/handlers"
	"gitlab.com/knackwurstking/shift-scheduler/internal/tr"

	"github.com/nanu-c/qml-go"
)

var ErrorLogger = constants.ErrorLogger

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
	ctxObject, err := ctxobject.NewCtxObject(constants.APPLICATION_NAME, constants.CONFIG_NAME)
	if err != nil {
		log.Panicf("initialize settings failed: %s", err.Error())
	}

	// get database path
	var databasePath string
	homeDir, err := os.UserHomeDir()
	if err == nil {
		databasePath = filepath.Join(
			homeDir, ".local", "share", constants.APPLICATION_NAME, constants.DATABASE_NAME,
		)
	}

	// initialize database (sqlite3)
	sqlDB, err := db.NewSQLiteDataBase(databasePath)
	if err != nil {
		ErrorLogger.Printf("initialize database failed: %s", err.Error())
	}
	defer sqlDB.Close()

	// set context (qml)
	ctx.SetVar("tr", tr.NewTr(constants.LANGUAGE))
	ctx.SetVar("ctxo", ctxObject)
	ctx.SetVar("mh", handlers.NewMonthHandler(ctxObject, sqlDB))

	win := component.CreateWindow(nil)
	win.Show()
	win.Wait()

	return nil
}
