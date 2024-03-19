import gleam/io
import gleam/list

pub type Model {
  Model(first: String, second: Bool, third: Int, fourth: Float)
}

type Setter =
  fn(Model) -> Model

fn init(setters: List(Setter)) {
  // defaults
  let model = Model("", False, 1, 2.3)
  use model, setter <- list.fold(setters, model)
  setter(model)
}

fn set_string_param(param) -> Setter {
  fn(model) { Model(..model, first: param) }
}

fn set_bool_param(param) -> Setter {
  fn(model) { Model(..model, second: param) }
}

pub fn main() {
  let something = init([])
  io.debug(something)
  let something = init([set_string_param("HELLO"), set_bool_param(True)])
  io.debug(something)

  let count = new(0)
  io.debug(count.count)
  io.debug(count.count)
}

pub type Counter {
  Counter(count: Int, next: fn() -> Counter)
}

fn new(from: Int) -> Counter {
  Counter(from, fn() { new(from + 1) })
}
