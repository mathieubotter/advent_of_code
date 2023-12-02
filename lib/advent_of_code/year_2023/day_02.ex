defmodule AdventOfCode.Year2023.Day02 do
  @max_cubes_per_color [red: 12, green: 13, blue: 14]

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn game, acc ->
      ["Game " <> id, records] = String.split(game, ":")

      String.split(records, [",", ";"])
      |> Stream.map(&color_value/1)
      |> Stream.map(&exceeds_max?/1)
      |> Enum.any?()
      |> if(do: acc, else: String.to_integer(id) + acc)
    end)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(0, fn game, acc ->
      [_, records] = String.split(game, ":")

      String.split(records, [",", ";"])
      |> Enum.map(&color_value/1)
      |> Enum.reduce([0, 0, 0], &min_set/2)
      |> Enum.product()
      |> Kernel.+(acc)
    end)
  end

  defp color_value([value, color]), do: {String.to_atom(color), String.to_integer(value)}
  defp color_value(reveal), do: String.split(reveal, " ", trim: true) |> color_value()

  defp exceeds_max?({color, value}), do: value > Keyword.get(@max_cubes_per_color, color)

  defp min_set({:red, value}, [red, green, blue]), do: [max(value, red), green, blue]
  defp min_set({:green, value}, [red, green, blue]), do: [red, max(value, green), blue]
  defp min_set({:blue, value}, [red, green, blue]), do: [red, green, max(value, blue)]
end
