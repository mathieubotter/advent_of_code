defmodule AdventOfCode.Year2023.Day06Test do
  use ExUnit.Case
  import AdventOfCode.Year2023.Day06

  @input """
  Time:      7  15   30
  Distance:  9  40  200
  """

  test "part1" do
    assert part1(@input) == 288
  end

  test "part2" do
    assert part2(@input) == 71503
    assert part2_fast(@input) == 71503
  end
end
