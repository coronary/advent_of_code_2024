import aoc_2024/utils
import gleam/int
import gleam/io
import gleam/list
import gleam/pair

pub fn pt_1(input: String) {
  input
  |> gather_reports
  |> run_reports
  |> io.debug
}

pub fn pt_2(input: String) {
  input
  |> gather_reports
  |> expand_lists
  |> run_reports
  |> io.debug
}

fn run_reports(on list: List(List(Int))) -> Int {
  list
  |> list.fold(0, fn(acc: Int, report: List(Int)) {
    let is_valid = is_valid_report(report |> list.window_by_2)
    case is_valid {
      True -> acc + 1
      False -> acc
    }
  })
}

fn gather_reports(input: String) -> List(List(Int)) {
  let x =
    input
    |> utils.split_newline_cases
    |> list.map(fn(x) { utils.parse_list_as_int(x, " ") })
    |> list.filter_map(fn(report) {
      // filters out reports with less than two levels
      case report {
        [_, _, ..] -> Ok(report)
        _ -> Error(Nil)
      }
    })
  x
}

fn list_without_value(values: List(a), index: Int) -> List(a) {
  let #(before, after) = list.split(values, index)
  list.append(before, list.drop(after, 1))
}

fn is_valid_report(report: List(#(Int, Int)), dampener: Bool) -> Bool {
  let is_ascending =
    report |> list.any(fn(elem) { pair.first(elem) < pair.second(elem) })
  report
  |> list.all(fn(x) { is_valid_step(x, is_ascending) })
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

fn expand_lists(list: List(List(Int))) -> List(List(Int)) {
  let prod =
    list
    |> list.map(fn(li: List(Int)) {
      let x =
        li
        |> list.index_map(fn(_: Int, index: Int) {
          list_without_value(li, index)
        })
      io.debug(x)
      x
    })
    |> list.flatten
  prod
}
