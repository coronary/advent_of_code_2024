import aoc_2024/utils
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp.{type Match}

type Action {
  Do
  Dont
  Mult
}

pub fn pt_1(input: String) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d{0,3}),(\\d{0,3})\\)")
  re
  |> regexp.scan(input)
  |> list.map(get_ints_from_match)
  |> list.fold(0, mult_and_add)
  |> io.debug
}

pub fn pt_2(input: String) {
  let assert Ok(re) =
    regexp.from_string("don't\\(\\)|do\\(\\)|mul\\((\\d{0,3}),(\\d{0,3})\\)")
  re
  |> regexp.scan(input)
  |> solve_part_2(Do, 0)
  |> io.debug
}

/// recursive function that treats the list of regex matches like a queue
/// conditionally multiplies and adds based on the last seen Action statement
fn solve_part_2(
  on list: List(Match),
  permission perm: Action,
  accumulator acc: Int,
) -> Int {
  case list {
    [match, ..rest] ->
      case match.content |> get_action_from_text {
        Do -> solve_part_2(rest, Do, acc)
        Dont -> solve_part_2(rest, Dont, acc)
        Mult ->
          case perm {
            Do ->
              solve_part_2(
                rest,
                perm,
                match |> get_ints_from_match |> mult_and_add(acc, _),
              )
            Dont -> solve_part_2(rest, perm, acc)
            _ -> panic as "should never be Mult here"
          }
      }
    _ -> acc
  }
}

fn get_ints_from_match(match: Match) -> List(Int) {
  match.submatches
  |> list.map(fn(match) {
    case match {
      Some(str) -> str |> utils.assert_as_int
      _ -> 0
    }
  })
}

fn mult_and_add(additive acc: Int, multiply numbers: List(Int)) -> Int {
  case numbers {
    [x, y, ..] -> int.multiply(x, y) |> int.add(acc)
    _ -> acc
  }
}

fn get_action_from_text(content: String) {
  case content {
    "do()" -> Do
    "don't()" -> Dont
    "mul" <> _ -> Mult
    _ -> Dont
  }
}
