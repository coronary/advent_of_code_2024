import gleam/int
import gleam/list
import gleam/pair
import gleam/string

pub fn pt_1(input: String) {
  input
  |> parse_lists
  |> list_difference
}

pub fn pt_2(input: String) {
  input
  |> parse_lists
  |> list_sync
}

fn list_sync(lists: #(List(Int), List(Int))) {
  lists |> list_sync_helper(0)
}

fn list_sync_helper(lists: #(List(Int), List(Int)), sync_rating: Int) {
  let #(l1, l2) = lists
  case l1 {
    [x, ..rest] ->
      list_sync_helper(
        #(rest, l2),
        sync_rating + int.multiply(x, list.count(l2, fn(a) { a == x })),
      )
    [] -> sync_rating
  }
}

fn parse_lists(input: String) {
  input
  |> string.replace("   ", ",")
  |> string.replace("\n", ",")
  |> string.split(",")
  |> list.map(assert_as_int)
  |> separate_cols
}

fn separate_cols(input: List(Int)) -> #(List(Int), List(Int)) {
  input |> separate_columns_recurs([], [], True)
}

fn separate_columns_recurs(
  input: List(Int),
  l1: List(Int),
  l2: List(Int),
  is_even_index index: Bool,
) -> #(List(Int), List(Int)) {
  case input, index {
    [x, ..rest], True ->
      separate_columns_recurs(rest, l1 |> list.prepend(x), l2, False)
    [x, ..rest], False ->
      separate_columns_recurs(rest, l1, l2 |> list.prepend(x), True)
    _, _ -> #(l1, l2)
  }
}

fn assert_as_int(str_num: String) {
  let assert Ok(num) = str_num |> int.parse
  num
}

fn list_difference(cols: #(List(Int), List(Int))) -> Int {
  get_list_diff(
    cols |> pair.first |> list.sort(int.compare),
    cols |> pair.second |> list.sort(int.compare),
    0,
  )
}

fn get_list_diff(list_1: List(Int), list_2: List(Int), acc: Int) -> Int {
  // takes two lists and calculates the difference between them
  case list_1, list_2 {
    [x, ..x_rest], [y, ..y_rest] ->
      get_list_diff(
        x_rest,
        y_rest,
        int.subtract(x, y) |> int.absolute_value |> int.add(acc),
      )
    _, _ -> acc
  }
}
