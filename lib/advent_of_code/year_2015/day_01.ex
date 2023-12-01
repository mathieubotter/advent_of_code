defmodule AdventOfCode.Year2015.Day01 do
  import Enum, only: [frequencies: 1, reduce_while: 3]

  def part1(input) do
    input |> to_charlist() |> frequencies() |> santa_floor()
  end

  defp santa_floor(%{40 => up, 41 => down}), do: up - down

  def part2(input) do
    input |> to_charlist() |> reduce_while({0, 0}, &basement_pos/2)
  end

  defp basement_pos(_, {pos, -1}), do: {:halt, pos}
  defp basement_pos(40, {pos, floor}), do: {:cont, {pos + 1, floor + 1}}
  defp basement_pos(41, {pos, floor}), do: {:cont, {pos + 1, floor - 1}}
end
