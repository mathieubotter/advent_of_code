defmodule AdventOfCode.Year2023.Day06 do
  def part1(input) do
    parse(input)
    |> Enum.reduce([], &wins_count/2)
    |> Enum.product()
  end

  def part2(input) do
    [race] = parse(input, &parse_single/1)
    wins_count(race)
  end

  defp parse(input, fun \\ &parse_multi/1) do
    ["Time:" <> times, "Distance:" <> records] =
      String.split(input, "\n", trim: true)

    Enum.zip(fun.(times), fun.(records))
  end

  defp parse_multi(line),
    do: String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1)

  defp parse_single(line),
    do: [String.replace(line, " ", "") |> String.to_integer()]

  defp wins_count(race, wins),
    do: [wins_count(race) | wins]

  defp wins_count({time, record}) do
    0..time
    |> Stream.map(&hold_to_distance(&1, time))
    |> Stream.filter(&(&1 > record))
    |> Enum.count()
  end

  defp hold_to_distance(hold, time),
    do: (time - hold) * hold

  @doc """
  Not my solution, as it was inspired by:
  https://elixirforum.com/t/advent-of-code-2023-day-6/60196/4

  This solution is based on the quadratic equation.
  This is to illustrate the difference of time between the two solutions.
  """
  def part2_fast(input) do
    [{time, distance}] = parse(input, &parse_single/1)
    fast_wins_count(time, distance)
  end

  # Quadratic equation:
  #   ax² + bx + c
  # Formula:
  #   x = [-b ± √(b²-4ac)] / 2a
  defp fast_wins_count(time, distance) do
    sqrt_discriminant = :math.sqrt(time * time - 4 * distance)
    root1 = ceil((time - sqrt_discriminant) / 2)
    root2 = floor((time + sqrt_discriminant) / 2)
    root2 - root1 + 1
  end
end
