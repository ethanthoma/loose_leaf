import teashop/event
import teashop/key
import gleam/dict
import gleam/int
import gleam/result
import gleam/string
import loose_leaf/cursor

type KeyMap =
  dict.Dict(key.Key, String)

fn default_key_map() -> KeyMap {
  dict.from_list([
    #(key.Right, "character_forward"),
    #(key.Left, "character_backward"),
    #(key.Ctrl(key.Right), "word_forward"),
    #(key.Ctrl(key.Left), "word_backward"),
    #(key.Ctrl(key.Char("k")), "delete_after_cursor"),
    #(key.Ctrl(key.Char("u")), "delete_before_cursor"),
    #(key.Backspace, "delete_character_backward"),
    #(key.Delete, "delete_character_forward"),
    #(key.Ctrl(key.Char("a")), "line_start"),
    #(key.Ctrl(key.Char("e")), "line_end"),
  ])
}

pub type Model {
  Model(
    prompt: String,
    cursor: cursor.Model,
    char_limit: Int,
    key_map: KeyMap,
    value: String,
    position: Int,
    offset: Int,
    offset_right: Int,
  )
}

pub fn new() {
  Model("> ", cursor.new(), 0, default_key_map(), "", 0, 0, 0)
}

pub fn update(model: Model, event) {
  let #(model, event) = case event {
    event.Key(key) ->
      case result.unwrap(dict.get(model.key_map, key), "") {
        "character_forward" -> #(character_forward(model), event)
        "character_backward" -> #(character_backward(model), event)
        "delete_character_backward" -> #(
          delete_character_backward(model),
          event,
        )
        "" -> {
          let model = case key {
            key.Char(char) -> {
              insert_character(model, char)
            }
            _ -> model
          }
          #(model, event)
        }
        _otherwise -> #(model, event)
      }
    _otherwise -> #(model, event)
  }

  #(handle_overflow(model), event)
}

fn character_forward(model: Model) {
  case model.position < string.length(model.value) {
    True -> set_cursor(model, model.position + 1)
    False -> model
  }
}

fn character_backward(model: Model) {
  case model.position > 0 {
    True -> set_cursor(model, model.position - 1)
    False -> model
  }
}

fn delete_character_backward(model: Model) {
  case string.length(model.value) > 0 {
    True -> {
      let value =
        string.slice(model.value, 0, int.max(0, model.position - 1))
        <> string.slice(model.value, model.position, string.length(model.value))
      let model = Model(..model, value: value)
      case model.position > 0 {
        True -> set_cursor(model, model.position - 1)
        False -> model
      }
    }
    False -> model
  }
}

fn insert_character(model: Model, char) {
  let head = string.slice(model.value, 0, model.position)
  let tail =
    string.slice(model.value, model.position, string.length(model.value))
  let value = head <> char <> tail
  character_forward(Model(..model, value: value))
}

fn handle_overflow(model: Model) {
  Model(..model, offset: 0, offset_right: string.length(model.value))
}

fn set_cursor(model: Model, position) {
  let position = int.clamp(position, 0, string.length(model.value))
  handle_overflow(Model(..model, position: position))
}

pub fn view(model: Model) {
  let value =
    string.slice(model.value, model.offset, model.offset_right - model.offset)
  let position = int.max(0, model.position - model.offset)
  let view = string.slice(value, 0, position)

  model.prompt
  <> case position < string.length(value) {
    True -> {
      let char = string.slice(value, position, 1)
      let c = cursor.set_char(model.cursor, char)
      view
      <> cursor.view(c)
      <> string.slice(value, position + 1, string.length(value))
    }
    False -> {
      let c = cursor.set_char(model.cursor, " ")
      view <> cursor.view(c)
    }
  }
}
