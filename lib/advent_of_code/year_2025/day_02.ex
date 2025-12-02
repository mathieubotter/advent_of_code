defmodule AdventOfCode.Year2025.Day02 do
  def part1(input) do
    input
    |> parse_ranges()
    |> find_patterns(&has_double_pattern?/1)
    |> Enum.uniq()
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_ranges()
    |> find_patterns(&has_repeating_pattern?/1)
    |> Enum.uniq()
    |> Enum.sum()
  end

  defp parse_ranges(input) do
    input
    |> String.split(["\n", ","], trim: true)
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(range_str) do
    [a, b] = String.split(range_str, "-", trim: true)
    {String.to_integer(a), String.to_integer(b)}
  end

  defp find_patterns(ranges, pattern_fun) do
    ranges
    |> Stream.flat_map(fn {a, b} -> a..b end)
    |> Stream.filter(pattern_fun)
  end

  defp has_double_pattern?(n) when n < 10, do: false

  defp has_double_pattern?(n) do
    digits = Integer.to_string(n)
    len = String.length(digits)
    half_size = div(len, 2)

    digits
    |> String.split_at(half_size)
    |> then(fn {a, b} -> a == b end)
  end

  defp has_repeating_pattern?(n) when n < 10, do: false

  defp has_repeating_pattern?(n) do
    digits = Integer.to_string(n)
    len = String.length(digits)

    1..div(len, 2)
    |> Enum.filter(&(rem(len, &1) == 0))
    |> Enum.any?(fn pattern_size ->
      digits
      |> chunk_string(pattern_size)
      |> all_same?()
    end)
  end

  defp chunk_string(string, size) do
    for <<chunk::binary-size(size) <- string>>, do: chunk
  end

  defp all_same?([]), do: false
  defp all_same?([_]), do: true
  defp all_same?([h | t]), do: Enum.all?(t, &(&1 == h))
end
