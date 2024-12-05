import aoc_2024/utils
import gleam/int
import gleam/io
import gleam/list

pub type Report {
  Increase(values: List(#(Int, Int)))
  Decrease(values: List(#(Int, Int)))
}

pub fn pt_1(input: String) {
  input
  |> utils.split_newline_cases
  |> list.map(fn(x) { utils.parse_list_as_int(x, " ") })
  |> list.filter_map(fn(report) {
    case report {
      [x, y, ..] if x < y -> Ok(Increase(report |> list.window_by_2))
      [x, y, ..] if x > y -> Ok(Decrease(report |> list.window_by_2))
      _ -> Error(Nil)
    }
  })
  |> list.fold(0, fn(acc: Int, report: Report) {
    let is_ascending = case report {
      Increase(_) -> True
      Decrease(_) -> False
    }
    let is_valid =
      report.values
      |> list.all(fn(levels_pair: #(Int, Int)) {
        is_valid_step(levels_pair, is_ascending)
      })
    case is_valid {
      True -> acc + 1
      False -> acc
    }
  })
  |> io.debug
}

fn is_within_bounds(x: Int, y: Int) -> Bool {
  int.subtract(x, y)
  |> int.absolute_value
  |> fn(a) { 0 < a && a < 4 }
}

fn is_valid_step(levels: #(Int, Int), is_ascending: Bool) -> Bool {
  let #(x, y) = levels
  case is_within_bounds(x, y), is_ascending {
    True, True if x < y -> True
    True, False if x > y -> True
    False, _ -> False
    _, _ -> False
  }
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
