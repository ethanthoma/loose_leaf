import teashop/command
import teashop/duration
import teashop/event

pub type Model {
  Model(
    style: String,
    char: String,
    focus: Bool,
    blink: Bool,
    show: Bool,
    blink_speed: duration.Duration,
  )
}

pub fn initial_model() {
  Model("|", " ", True, True, True, duration.milliseconds(600))
}

pub fn style(model, style) {
  Model(..model, style: style)
}

pub fn char(model, char) {
  Model(..model, char: char)
}

pub fn blink(model, blink) {
  Model(..model, blink: blink)
}

pub fn blink_speed(model, blink_speed) {
  Model(..model, blink_speed: blink_speed)
}

pub fn update(model: Model, event) {
  case event {
    event.Custom(msg) if msg == "blink" -> {
      let model = blink(model, !model.blink)
      let command = blink_event(model)
      #(model, command)
    }
    _otherwise -> #(model, command.none())
  }
}

pub fn blink_event(model: Model) {
  command.set_timer("blink", model.blink_speed)
}

pub fn view(model: Model) {
  case model.blink {
    True -> model.char
    False -> model.style
  }
}
