defmodule AdventOfCode.Year2025.Day05Test do
  use ExUnit.Case
  import AdventOfCode.Year2025.Day05

  @input """
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  test "part1" do
    assert part1(@input) == 3
    assert part1_merged_ranges(@input) == 3
    assert part1_binary_search(@input) == 3
  end

  test "part2" do
    assert part2(@input) == 14
  end
end
