defmodule AdventOfCode.Year2023.Day13 do
  def part1(input) do
    parse(input)
    |> Enum.map(&summarize/1)
    |> Enum.sum()
  end

  def part2(input) do
    parse(input)
    |> Enum.map(&summarize(&1, with_smudge: true))
    |> Enum.sum()
  end

  defp summarize(pattern, opts \\ []) do
    h_index = find_index(pattern, opts)
    v_index = find_index(transpose(pattern), opts)

    cond do
      h_index -> 100 * (h_index + 1)
      v_index -> v_index + 1
      true -> 0
    end
  end

  defp find_index(pattern, opts) do
    with_smudge = Keyword.get(opts, :with_smudge, false)
    max_index = length(pattern) - 2

    Enum.reduce_while(0..max_index, nil, fn i, acc ->
      Enum.reduce_while(0..min(i, max_index - i), 0, fn l, diff ->
        row1 = Enum.at(pattern, i - l)
        row2 = Enum.at(pattern, i + l + 1)

        if with_smudge do
          Enum.zip(row1, row2)
          |> Enum.reduce(diff, fn {r1, r2}, acc ->
            if r1 != r2, do: acc + 1, else: acc
          end)
          |> then(&{:cont, &1})
        else
          if row1 == row2,
            do: {:cont, 1},
            else: {:halt, nil}
        end
      end)
      |> case do
        1 -> {:halt, i}
        _ -> {:cont, acc}
      end
    end)
  end

  defp parse(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(&parse_pattern/1)
  end

  defp parse_pattern(pattern) do
    pattern
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def transpose(rows) do
    rows
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
