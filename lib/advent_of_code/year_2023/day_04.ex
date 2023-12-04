defmodule AdventOfCode.Year2023.Day04 do
  def part1(input) do
    parse(input)
    |> Enum.map(&matching_numbers/1)
    |> Enum.map(&double(length(&1)))
    |> Enum.sum()
  end

  def part2(input) do
    scratchcards =
      parse(input)
      |> Enum.map(&matching_numbers/1)
      |> Enum.with_index(fn matches, i -> {length(matches), i, 1} end)

    scratchcards
    |> Enum.reduce(scratchcards, fn {matches, i, _copies}, updated_scratchcards ->
      {_, _, copies} = Enum.at(updated_scratchcards, i)

      next = i + 1
      last = i + matches

      if next <= last,
        do: Enum.reduce(next..last, updated_scratchcards, &update_copies_at(&2, &1, copies)),
        else: updated_scratchcards
    end)
    |> Enum.map(&get_copies/1)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, [":", "|"], trim: true))
    |> Enum.map(&parse_card/1)
  end

  defp parse_card([_card, winning_numbers, my_numbers]) do
    parse = &String.split(&1, " ", trim: true)
    {parse.(winning_numbers), parse.(my_numbers)}
  end

  defp matching_numbers({winning_numbers, my_numbers}) do
    MapSet.intersection(MapSet.new(winning_numbers), MapSet.new(my_numbers)) |> MapSet.to_list()
  end

  defp double(n) when n > 1, do: Enum.reduce(2..n, 1, fn _n, acc -> acc * 2 end)
  defp double(n), do: n

  defp update_copies_at(list, i, copies), do: List.update_at(list, i, &update_copies(&1, copies))
  defp update_copies({matches, i, copies}, value), do: {matches, i, copies + value}
  defp get_copies({_matches, _i, copies}), do: copies
end
