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

	"gitlab.com/knackwurstking/shift-scheduler/pkg/db"
	"gitlab.com/knackwurstking/shift-scheduler/pkg/settings"
	"gitlab.com/knackwurstking/shift-scheduler/pkg/tr"

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

	_tr := tr.NewTr(LANGUAGE) // NOTE: de_DE, en_EN
	ctx.SetVar("tr", &_tr)

	sqlDB, err := db.NewSQLiteDataBase(getDataBasePath())
	if err != nil {
		log.Println("initialize database failed:", err.Error())
		log.Println(getDataBasePath())
	}
	defer sqlDB.DB.Close()

	ctx.SetVar("db", sqlDB)

	_settings, err := settings.NewSettings(
		APPLICATION_NAME,
		CONFIG_NAME,
		sqlDB,
	)

	if err != nil {
		log.Println("initialize settings failed:", err.Error())
	}

	ctx.SetVar("settings", &_settings)

	win := component.CreateWindow(nil)
	win.Show()
	win.Wait()

	return nil
}

func getDataBasePath() string {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return DATABASE_NAME
	}

	return filepath.Join(homeDir, ".local", "share", APPLICATION_NAME, DATABASE_NAME)
}
