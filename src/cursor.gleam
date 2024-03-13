pub type Model {
  Model(char: String, blink: Bool)
}

pub fn new() {
  Model("❚", False)
}

pub fn set_char(model, char) {
    Model(..model, char: char)
}

pub fn update(model: Model, _event) {
   case model.blink {
        True -> False
        False -> True
    }
}

pub fn view(model: Model) {
    case model.blink {
        True -> " "
        False -> model.char
    }
}
