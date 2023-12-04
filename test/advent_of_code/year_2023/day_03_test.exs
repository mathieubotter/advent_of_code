defmodule AdventOfCode.Year2023.Day03Test do
  use ExUnit.Case
  import AdventOfCode.Year2023.Day03

  @input """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test "part1" do
    assert part1(@input) == 4361
  end

  test "part2" do
    assert part2(@input) == 467_835
  end
end
