defmodule AdventOfCode.Year2025.Day03Test do
  use ExUnit.Case
  import AdventOfCode.Year2025.Day03

  @input """
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  test "part1" do
    assert part1(@input) == 357
  end

  test "part2" do
    assert part2(@input) == 3_121_910_778_619
  end
end
