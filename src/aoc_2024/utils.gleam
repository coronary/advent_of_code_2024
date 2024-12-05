import gleam/int
import gleam/list
import gleam/string

pub fn parse_list_as_int(input: String, separator: String) -> List(Int) {
  input
  |> string.trim
  |> string.split(separator)
  |> list.map(assert_as_int)
}

pub fn split_newline_cases(input: String) {
  input
  |> string.split("\n")
}

pub fn assert_as_int(str_num: String) {
  let assert Ok(num) = str_num |> int.parse
  num
}
