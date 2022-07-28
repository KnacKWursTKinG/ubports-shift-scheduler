package db

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strconv"

	_ "github.com/mattn/go-sqlite3"
)

// database for storing notes and (special) shifts for each day
type SQLiteDateBase struct {
	DB *sql.DB
}

func (db *SQLiteDateBase) Close() error {
	return db.DB.Close()
}

func (db *SQLiteDateBase) Initialize() error { // <<-
	// NOTE: special key (date) `YYYYMMDD`
	// NOTE: notes (REAL) - ignore for now (only shifts matter)
	query := `
	CREATE TABLE IF NOT EXISTS dates(
		id INTEGER UNIQUE PRIMARY KEY,
		notes REAL,
		shift TEXT
	)
	`

	_, err := db.DB.Exec(query)
	return err
} // ->>

func (db *SQLiteDateBase) Remove(id int) (err error) { // <<-
	_, err = db.DB.Exec(`delete from dates where id=?`, id)
	return err
} // ->>

func (db *SQLiteDateBase) GetNotes(id int) string { // <<-
	var data []byte
	row := db.DB.QueryRow(`select notes from dates where id=?`, id)
	row.Scan(&data)
	return string(data)
} // ->>

func (db *SQLiteDateBase) SetNotes(id int, notes string) (err error) { // <<-
	_, err = db.DB.Exec(`insert into dates (id, notes) values (?, ?)`, id, []byte(notes))

	if err != nil {
		_, err = db.DB.Exec(`update dates set notes=? where id=?`, []byte(notes), id)
	}

	return err
} // ->>

func (db *SQLiteDateBase) RemoveNotes(id int) (err error) { // <<-
	_, err = db.DB.Exec(`update dates set notes=? where id=?`, []byte(""), id)
	if err != nil {
		return err
	}

	if db.IsEmptyRow(id) {
		err = db.Remove(id)
	}

	return err
} // ->>

func (db *SQLiteDateBase) GetShift(id int) (shift string) { // <<-
	row := db.DB.QueryRow(`select shift from dates where id=?`, id)
	row.Scan(&shift)
	return shift
} // ->>

func (db *SQLiteDateBase) SetShift(id int, shift string) (err error) { // <<-
	log.Printf("%d: set shift \"%s\" in database table \"dates\"\n", id, shift)

	_, err = db.DB.Exec(`insert into dates (id, shift) values (?, ?)`, id, shift)

	if err != nil {
		_, err = db.DB.Exec(`update dates set shift=? where id=?`, shift, id)
	}

	return err
} // ->>

func (db *SQLiteDateBase) RemoveShift(id int) (err error) { // <<-
	_, err = db.DB.Exec(`update dates set shift=? where id=?`, "", id)
	if err != nil {
		return err
	}

	if db.IsEmptyRow(id) {
		log.Printf("row in table \"dates\" with id %d is empty ... will be removed (shift)\n", id)
		err = db.Remove(id)
	}

	return err
} // ->>

func (*SQLiteDateBase) BuildID(year, month, day int) (id int) { // <<-
	id, _ = strconv.Atoi(fmt.Sprintf("%d%02d%02d", year, month, day))
	return id
} // ->>

func (db *SQLiteDateBase) IsEmptyRow(id int) bool { // <<-
	var (
		notes []byte
		shift string
	)
	row := db.DB.QueryRow(`select notes, shift from dates where id=?`, id)
	row.Scan(&notes, &shift)

	return len(notes) == 0 && shift == ""
} // ->>

func NewSQLiteDataBase(databasePath string) (*SQLiteDateBase, error) {
	dirPath := filepath.Dir(databasePath)
	if _, err := os.Stat(dirPath); os.IsNotExist(err) {
		os.MkdirAll(dirPath, 0700)
	}

	db, err := sql.Open("sqlite3", databasePath)
	if err != nil {
		return nil, err
	}

	sqlDB := SQLiteDateBase{
		DB: db,
	}

	err = sqlDB.Initialize()

	if err != nil {
		return nil, err
	}

	return &sqlDB, nil
}
