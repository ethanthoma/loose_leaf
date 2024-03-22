import teashop/command
import teashop/duration
import teashop/event

pub opaque type BlinkState {
  Initial
  Msg(id: Int, tag: Int)
}

pub type Model {
  Model(
    char: String,
    blink: Bool,
    blink_speed: duration.Duration,
    focus: Bool,
    id: Int,
    show: Bool,
    style: String,
    tag: Int,
  )
}

pub fn initial_model() {
  Model(
    char: " ",
    blink: True,
    blink_speed: duration.milliseconds(530),
    focus: True,
    id: 0,
    show: True,
    style: "█",
    tag: 0,
  )
}

pub fn blink(model, blink) {
  Model(..model, blink: blink)
}

pub fn blink_speed(model, blink_speed) {
  Model(..model, blink_speed: blink_speed)
}

pub fn char(model, char) {
  Model(..model, char: char)
}

pub fn style(model, style) {
  Model(..model, style: style)
}

pub fn update(model: Model, event) {
  case event {
    event.Custom(msg) ->
      case msg {
        Initial -> {
          case model.focus {
            True -> blink_command(model)
            False -> #(model, command.none())
          }
        }
        Msg(id, tag) ->
          case id != model.id || tag != model.tag {
            True -> #(model, command.none())
            False ->
              blink_command(
                model
                |> blink(!model.blink),
              )
          }
      }
    _otherwise -> #(model, command.none())
  }
}

pub fn start_blink(_model: Model) {
  command.set_timer(Initial, duration.milliseconds(0))
}

pub fn blink_command(model: Model) {
  let tag = model.tag + 1
  let model = Model(..model, tag: tag)
  let command =
    command.set_timer(Msg(id: model.id, tag: tag), model.blink_speed)
  #(model, command)
}

pub fn view(model: Model) {
  case model.blink {
    True -> model.char
    False -> model.style
  }
}
