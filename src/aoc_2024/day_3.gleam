import aoc_2024/utils
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp

pub fn pt_1(input: String) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d{0,3}),(\\d{0,3})\\)")
  re
  |> regexp.scan(input)
  |> list.map(fn(matches) {
    matches.submatches
    |> list.map(fn(match) {
      case match {
        Some(str) -> str |> utils.assert_as_int
        _ -> 0
      }
    })
  })
  |> list.fold(0, fn(acc, group) {
    case group {
      [x, y, ..] -> int.multiply(x, y) |> int.add(acc)
      _ -> acc
    }
  })
  |> io.debug
}

pub fn pt_2(input: String) {
  todo as "part 2 not implemented"
}
