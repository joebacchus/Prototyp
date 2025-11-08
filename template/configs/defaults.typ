#let share = {
  json("../workspace/sharables/objects.json").pairs()
    .map(((k, (kind, meta, value))) => {
      if kind == "svg" {
        value = align(center+horizon,image(bytes(value)))
      } else if kind == "csv" {
        let raw_value = csv(bytes(value))
        value = align(center+horizon,table(columns: meta.at(1), ..raw_value.flatten()))
      }
      (k, value)
    }).to-dict()
}

