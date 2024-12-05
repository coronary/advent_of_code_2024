import aoc_2024/utils
import gleam/int
import gleam/io
import gleam/list
import gleam/pair

pub type Report {
  Increase(values: List(#(Int, Int)))
  Decrease(values: List(#(Int, Int)))
}

pub fn pt_1(input: String) {
  input
  |> utils.split_newline_cases
  |> list.map(fn(x) { utils.parse_list_as_int(x, " ") })
  |> list.filter_map(fn(report) {
    // filters out reports with less than two levels
    case report {
      [x, y, ..] if x < y -> Ok(report)
      _ -> Error(Nil)
    }
  })
  |> list.fold(0, fn(acc: Int, report: List(Int)) {
    //counting step for valid reports
    let is_valid = is_valid_report(report |> list.window_by_2)
    case is_valid {
      True -> acc + 1
      False -> acc
    }
  })
  |> io.debug
}

fn is_valid_report(report: List(#(Int, Int))) -> Bool {
  let is_ascending =
    report |> list.any(fn(elem) { pair.first(elem) < pair.second(elem) })
  report |> list.all(fn(x) { is_valid_step(x, is_ascending) })
  //check for ascending here
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
