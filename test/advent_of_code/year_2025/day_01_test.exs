defmodule AdventOfCode.Year2025.Day01Test do
  use ExUnit.Case
  import AdventOfCode.Year2025.Day01

  @input """
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  test "part1" do
    assert part1(@input) == 3
  end

  test "part2" do
    assert part2(@input) == 6
  end
end
