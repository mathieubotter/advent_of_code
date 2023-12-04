defmodule AdventOfCode.Year2023.Day01 do
  @digits ~w(1 2 3 4 5 6 7 8 9)
  @spelled_out_digits ~w(one two three four five six seven eight nine)

  def part1(input) do
    parse(input)
    |> Stream.map(&calibration_value/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part2(input) do
    parse(input)
    |> Stream.map(&calibration_value(&1, true))
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp parse(input), do: String.split(input, "\n", trim: true)

  defp calibration_value(line),
    do: digit(line, false) <> digit(String.reverse(line), false)

  defp calibration_value(line, true),
    do: digit(line, :forward) <> digit(String.reverse(line), :reverse)

  defp digit("", _), do: "0"

  for {spelled_out, index} <- Enum.with_index(@spelled_out_digits, &{&1, &2 + 1}) do
    defp digit(unquote(spelled_out) <> _rest, :forward), do: unquote(to_string(index))

    defp digit(unquote(String.reverse(spelled_out)) <> _rest, :reverse),
      do: unquote(to_string(index))
  end

  defp digit(<<d::binary-size(1), _rest::binary>>, _) when d in @digits, do: d
  defp digit(<<_d::binary-size(1), rest::binary>>, spelled_out), do: digit(rest, spelled_out)
end
