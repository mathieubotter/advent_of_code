defmodule AdventOfCode.Year2023.Day07Test do
  use ExUnit.Case
  import AdventOfCode.Year2023.Day07

  @input1 """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  @input2 """
  2345A 1
  Q2KJJ 13
  Q2Q2Q 19
  T3T3J 17
  T3Q33 11
  2345J 3
  J345A 2
  32T3K 5
  T55J5 29
  KK677 7
  KTJJT 34
  QQQJA 31
  JJJJJ 37
  JAAAA 43
  AAAAJ 59
  AAAAA 61
  2AAAA 23
  2JJJJ 53
  JJJJ2 41
  """

  test "part1" do
    assert part1(@input1) == 6440
    assert part1(@input2) == 6592
  end

  test "part2" do
    assert part2(@input1) == 5905
    assert part2(@input2) == 6839
  end
end
