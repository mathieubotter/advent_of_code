defmodule AdventOfCode.Year2024.Day01 do
  def part1(input) do
    {left, right} = parse(input)
    {left, right} = {Enum.sort(left), Enum.sort(right)}
    distance_sum(left, right)
  end

  def part2(input) do
    {left, right} = parse(input)
    similarity_score_sum(left, right)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "   "))
    |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    |> Enum.unzip
  end

  defp distance_sum(left, right),
    do: Enum.zip_reduce(left, right, 0, fn l, r, acc -> abs(l - r) + acc end)

  defp similarity_score_sum(left, right) do
    Enum.reduce(left, 0, fn l, acc ->
      count = Enum.count(right, fn r -> l == r end)
      acc + l * count
    end)
  end
end
