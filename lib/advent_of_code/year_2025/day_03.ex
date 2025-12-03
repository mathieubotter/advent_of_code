defmodule AdventOfCode.Year2025.Day03 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&pick_highests(&1, 2))
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&pick_highests(&1, 12))
    |> Enum.sum()
  end

  defp pick_highests(line, amount) do
    max_index = String.length(line) - amount

    line
    |> String.graphemes()
    |> Enum.with_index()
    |> do_pick(amount, max_index, [])
    |> Enum.join()
    |> String.to_integer()
  end

  defp do_pick(_, 0, _, acc), do: Enum.reverse(acc)

  defp do_pick(indexed_digits, amount, max_index, acc) do
    {highest, index} =
      indexed_digits
      |> Enum.filter(fn {_, i} -> i <= max_index end)
      |> Enum.max_by(fn {d, _} -> d end)

    rest = Enum.filter(indexed_digits, fn {_, i} -> i > index end)
    do_pick(rest, amount - 1, max_index + 1, [highest | acc])
  end
end
