package tr

import (
	_ "embed"
	"strings"

	"github.com/leonelquinteros/gotext"
)

var (
	//go:embed lang/de.po
	de []byte

	//go:embed lang/en.po
	en []byte

	// NOTE: "en" is default
	PoLangDict = map[string][]byte{
		"de": de,
		"en": en,
	}
)

type Tr struct {
	lang string
	po   *gotext.Po
}

func (tr *Tr) GetLang() string {
	return tr.lang
}

// : lang: ex: en_EN, de_DE, en, de
func (tr *Tr) SetLang(lang string) {
	tr.lang = lang
	tr.po = gotext.NewPo()

	if _, ok := PoLangDict[lang]; !ok {
		lang = strings.Split(lang, "_")[0]
	}

	if _, ok := PoLangDict[lang]; ok {
		tr.po.Parse(PoLangDict[lang])
	} else {
		// default
		tr.po.Parse(PoLangDict["en"])
	}
}

func (tr *Tr) Get(str string) string {
	return tr.po.Get(str)
}

func (tr *Tr) GetWithVars(str string, vars ...interface{}) string {
	return tr.po.Get(str, vars...)
}

// : lang: ex: en_EN, de_DE, en, de
func NewTr(lang string) Tr {
	tr := Tr{}
	tr.SetLang(lang)
	return tr
}
