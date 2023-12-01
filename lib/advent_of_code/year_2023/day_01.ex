defmodule AdventOfCode.Year2023.Day01 do
  @digits ~w(1 2 3 4 5 6 7 8 9)

  def part1(input) do
    input
    |> String.split("\n")
    |> Stream.map(&calibration_value/1)
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n")
    |> Stream.map(&calibration_value(&1, true))
    |> Stream.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp calibration_value(line),
    do: digit(line, false) <> digit(String.reverse(line), false)

  defp calibration_value(line, true),
    do: digit(line, :forward) <> digit(String.reverse(line), :reverse)

  defp digit("", _), do: "0"
  defp digit("one" <> _rest, :forward), do: "1"
  defp digit("two" <> _rest, :forward), do: "2"
  defp digit("three" <> _rest, :forward), do: "3"
  defp digit("four" <> _rest, :forward), do: "4"
  defp digit("five" <> _rest, :forward), do: "5"
  defp digit("six" <> _rest, :forward), do: "6"
  defp digit("seven" <> _rest, :forward), do: "7"
  defp digit("eight" <> _rest, :forward), do: "8"
  defp digit("nine" <> _rest, :forward), do: "9"
  defp digit("eno" <> _rest, :reverse), do: "1"
  defp digit("owt" <> _rest, :reverse), do: "2"
  defp digit("eerht" <> _rest, :reverse), do: "3"
  defp digit("ruof" <> _rest, :reverse), do: "4"
  defp digit("evif" <> _rest, :reverse), do: "5"
  defp digit("xis" <> _rest, :reverse), do: "6"
  defp digit("neves" <> _rest, :reverse), do: "7"
  defp digit("thgie" <> _rest, :reverse), do: "8"
  defp digit("enin" <> _rest, :reverse), do: "9"
  defp digit(<<d::binary-size(1), _rest::binary>>, _) when d in @digits, do: d
  defp digit(<<_d::binary-size(1), rest::binary>>, spelled_out), do: digit(rest, spelled_out)
end
