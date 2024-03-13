import teashop
import teashop/command
import teashop/event
import teashop/key
import text_input

type Model {
  Model(text_input: text_input.Model)
}

fn initial_model() -> Model {
  Model(text_input: text_input.new())
}

fn init(_) {
  #(initial_model(), command.none())
}

// handle error msgs if exist
fn update(model: Model, event) {
  case event {
    event.Key(key) ->
      case key {
        key.Enter | key.Ctrl(key.Char("c")) | key.Esc -> #(
          model,
          command.quit(),
        )
        _otherwise -> {
          let #(text_input, _) = text_input.update(model.text_input, event)
          #(Model(text_input: text_input), command.none())
        }
      }
    _otherwise -> #(model, command.none())
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
