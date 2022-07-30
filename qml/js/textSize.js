.import Ubuntu.Components 1.3 as Components

const model = [
  null,
  "XXSmall",
  "XSmall",
  "Small",
  "Medium",
  "Large",
  "XLarge"
]

const data = [
  null,
  Components.Label.XxSmall,
  Components.Label.XSmall,
  Components.Label.Small,
  Components.Label.Medium,
  Components.Label.Large,
  Components.Label.XLarge
]

function defaultSizeName(name) {
  return name.length > 5 ? model[3] : name.length < 3 ? model[5] : model[4]
}

function defaultSize(name) {
  return data[model.indexOf(defaultSizeName(name))]
}

function get(name, textSize) {
  return (textSize || 0) > 0
    ? data[textSize]
    : defaultSize(name)
}
