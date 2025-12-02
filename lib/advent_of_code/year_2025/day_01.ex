defmodule AdventOfCode.Year2025.Day01 do
  @dial_size 100
  @starting_position 50

  def part1(input) do
    input
    |> parse_rotations()
    |> Enum.scan(@starting_position, &rem(&1 + &2, @dial_size))
    |> Enum.count(&(&1 == 0))
  end

  def part2(input) do
    input
    |> parse_rotations()
    |> count_crossings()
  end

  defp parse_rotations(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_rotation/1)
  end

  defp parse_rotation("L" <> distance), do: -String.to_integer(distance)
  defp parse_rotation("R" <> distance), do: String.to_integer(distance)
  defp parse_rotation(_), do: 0

  defp count_crossings(rotations) do
    rotations
    |> Enum.reduce({@starting_position, 0}, fn clicks, {position, total} ->
      end_position = position + clicks
      crossings = count_zero_crossings(position, end_position)
      new_position = Integer.mod(end_position, @dial_size)
      {new_position, total + crossings}
    end)
    |> elem(1)
  end

  defp count_zero_crossings(position, end_position) do
    full_rotations = div(abs(end_position), @dial_size)
    crossed_backwards = position != 0 and end_position <= 0

    if crossed_backwards, do: full_rotations + 1, else: full_rotations
  end
end
