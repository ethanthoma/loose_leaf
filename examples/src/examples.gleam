import teashop
import teashop/command
import teashop/event
import teashop/key
import loose_leaf/text_input

type Model {
  Model(text_input: text_input.Model)
}

fn initial_model() -> Model {
  let text_input =
    text_input.new()
    |> text_input.set_placeholder("green tea")
    |> text_input.set_focus(True)
  Model(text_input: text_input)
}

fn init(_) {
  let model = initial_model()
  let command =
    model.text_input
    |> text_input.blink
  #(model, command)
}

fn update(model: Model, event) {
  case event {
    event.Key(key.Enter)
    | event.Key(key.Ctrl(key.Char("c")))
    | event.Key(key.Esc) -> {
      #(model, command.quit())
    }
    _otherwise -> {
      let #(text_input, command) = text_input.update(model.text_input, event)
      #(Model(text_input: text_input), command)
    }
  }
}

fn view(model: Model) {
  "What’s your favorite tea?\n\n"
  <> text_input.view(model.text_input)
  <> "\n\n"
  <> "(enter/ctrl+c/esc to quit)"
}

pub fn main() {
  let app = teashop.app(init, update, view)
  teashop.start(app, Nil)
}
