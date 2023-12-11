defmodule AdventOfCode.Year2023.Day03 do
  @moduledoc """
  It's ugly and needs a lot of improvement...
  """

  @symbols ~w(- @ / & % + = $ #)

  def part1(input) do
    {parts, symbols} = parse(input)

    symbols
    |> Enum.map(&coordinates/1)
    |> Enum.flat_map(&adjacents(&1, parts))
    |> Enum.map(&value/1)
    |> Enum.sum()
  end

  def part2(input) do
    {parts, symbols} = parse(input)

    symbols
    |> Enum.filter(&is_gear?/1)
    |> Enum.map(&coordinates/1)
    |> Enum.reduce(0, fn coordinates, acc ->
      adjacents = adjacents(coordinates, parts)

      if length(adjacents) == 2 do
        adjacents
        |> Enum.map(&value/1)
        |> Enum.product()
        |> Kernel.+(acc)
      else
        acc
      end
    end)
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(&do_parse/1)
    |> Enum.split_with(&is_part?/1)
  end

  defp do_parse({line, y}), do: do_parse(line, 0, y, [])
  defp do_parse("", _, _, acc), do: acc
  defp do_parse("." <> rest, x, y, acc), do: do_parse(rest, x + 1, y, acc)

  defp do_parse("*" <> rest, x, y, acc),
    do: do_parse(rest, x + 1, y, [{:gear, {x, y}, "*"} | acc])

  defp do_parse(<<c::binary-1, rest::binary>>, x, y, acc) when c in @symbols,
    do: do_parse(rest, x + 1, y, [{:symbol, {x, y}, c} | acc])

  defp do_parse(<<c>> <> rest, x, y, acc) when c in ?0..?9 do
    {number, remaining} = do_parse_number(rest, [c])

    do_parse(remaining, x + String.length(number), y, [
      {:part, {x, y}, String.to_integer(number)} | acc
    ])
  end

  defp do_parse_number(<<>>, acc),
    do: {to_string(Enum.reverse(acc)), ""}

  defp do_parse_number(<<c>> <> rest, acc) when c in ?0..?9,
    do: do_parse_number(rest, [c | acc])

  defp do_parse_number(<<c>> <> rest, acc),
    do: {to_string(Enum.reverse(acc)), <<c::utf8, rest::binary>>}

  defp adjacents(coordinates, parts) do
    Enum.filter(parts, fn {_, {x, y}, number} ->
      for(
        x_range <- (x - 1)..(x + size(number)),
        y_range <- (y - 1)..(y + 1),
        do: {x_range, y_range}
      )
      |> Enum.any?(&(&1 == coordinates))
    end)
  end

  defp is_part?(element), do: match?({:part, _, _}, element)
  defp is_gear?(element), do: match?({:gear, _, _}, element)

  defp coordinates({_type, coordinates, _value}), do: coordinates
  defp value({_type, _coordinates, value}), do: value
  defp size(int) when is_integer(int), do: Integer.digits(int) |> length()
end
