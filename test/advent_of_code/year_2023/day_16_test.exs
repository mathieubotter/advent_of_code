defmodule AdventOfCode.Year2023.Day16Test do
  use ExUnit.Case
  import AdventOfCode.Year2023.Day16

  @input ~S"""
  .|...\....
  |.-.\.....
  .....|-...
  ........|.
  ..........
  .........\
  ..../.\\..
  .-.-/..|..
  .|....-|.\
  ..//.|....
  """

  test "part1" do
    assert part1(@input) == 46
  end

  test "part2" do
    assert part2(@input) == 51
  end

  test "part2_fast" do
    assert part2_fast(@input) == 51
  end
end
