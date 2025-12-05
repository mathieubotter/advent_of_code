defmodule AdventOfCode.Year2025.Day05 do
  @doc """
  A naive implementation of part1 that checks each ingredient against all ranges.
  """
  def part1(input) do
    {ranges, ingredients} = parse(input)

    Enum.count(ingredients, &in_any_range?(&1, ranges))
  end

  @doc """
  A faster implementation of part1 that merges ranges first.
  """
  def part1_merged_ranges(input) do
    {ranges, ingredients} = parse(input)

    merged_ranges =
      ranges
      |> Enum.sort_by(& &1.first)
      |> merge_ranges()

    Enum.count(ingredients, &in_any_range?(&1, merged_ranges))
  end

  @doc """
  A faster implementation of part1_merged_ranges that merges ranges first
  and uses binary search to find if an ingredient is in any range.
  """
  def part1_binary_search(input) do
    {ranges, ingredients} = parse(input)

    merged_ranges =
      ranges
      |> Enum.sort_by(& &1.first)
      |> merge_ranges()

    Enum.count(ingredients, &in_any_range_binary_search?(&1, merged_ranges))
  end

  def part2(input) do
    {ranges, _} = parse(input)

    ranges
    |> Enum.sort_by(& &1.first)
    |> merge_ranges()
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  defp parse(input) do
    [ranges_raw, ingredients_raw] = String.split(input, "\n\n", trim: true)
    {parse_ranges(ranges_raw), parse_ingredients(ingredients_raw)}
  end

  defp parse_ranges(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(range) do
    [low, high] = String.split(range, "-")
    String.to_integer(low)..String.to_integer(high)
  end

  defp parse_ingredients(raw) do
    raw
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp in_any_range?(value, ranges) do
    Enum.any?(ranges, &(value in &1))
  end

  defp in_any_range_binary_search?(value, ranges) do
    Enum.any?(ranges, fn range ->
      case value do
        _ when value < range.first -> false
        _ when value > range.last -> false
        _ -> true
      end
    end)
  end

  # Merges a list of contiguous overlapping ranges.
  # To merge all ranges into the smallest possible list of ranges, the input list
  # must be sorted by the first element of each range.
  defp merge_ranges([first | rest]) do
    rest
    |> Enum.reduce([first], fn range, [current | merged] ->
      if ranges_touch?(current, range) do
        [current.first..max(current.last, range.last) | merged]
      else
        [range, current | merged]
      end
    end)
  end

  defp ranges_touch?(r1, r2), do: r2.first <= r1.last + 1
end
