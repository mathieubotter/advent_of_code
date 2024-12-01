defmodule AdventOfCode.Year2024.Day01Test do
  use ExUnit.Case
  import AdventOfCode.Year2024.Day01

  test "part1" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert part1(input) == 11
  end

  test "part2" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert part2(input) == 31
  end
end
