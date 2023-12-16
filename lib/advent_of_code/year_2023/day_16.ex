defmodule AdventOfCode.Year2023.Day16 do
  def part1(input) do
    parse(input) |> energize({0, 0, :right})
  end

  def part2(input) do
    grid = parse(input)

    get_beams(grid)
    |> Enum.map(&energize(grid, &1))
    |> Enum.max()
  end

  def part2_fast(input) do
    grid = parse(input)

    get_beams(grid)
    |> Task.async_stream(&energize(grid, &1))
    |> Enum.map(fn {:ok, result} -> result end)
    |> Enum.max()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  defp energize(grid, beam) do
    energize(grid, beam, MapSet.new())
    |> MapSet.to_list()
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp energize(grid, beam, energized) do
    is_tile_energized? = MapSet.member?(energized, beam)
    current_tile = get_tile(grid, beam)

    if is_tile_energized? or is_nil(current_tile) do
      energized
    else
      energized = MapSet.put(energized, beam)

      case next_tile(beam, current_tile) do
        [new_beam1, new_beam2] ->
          energize(grid, new_beam1, energized) |> then(&energize(grid, new_beam2, &1))

        new_beam ->
          energize(grid, new_beam, energized)
      end
    end
  end

  defp get_beams(grid) do
    row_count = length(grid) - 1
    col_count = length(Enum.at(grid, 0)) - 1

    lr_beams = Enum.flat_map(0..row_count, &[{0, &1, :right}, {col_count, &1, :left}])
    ud_beams = Enum.flat_map(0..col_count, &[{&1, 0, :down}, {&1, row_count, :up}])
    lr_beams ++ ud_beams
  end

  defp get_tile(_, {x, y, _}) when x < 0 or y < 0,
    do: nil

  defp get_tile(grid, {x, y, _}) do
    row = Enum.at(grid, y)
    if row, do: Enum.at(row, x), else: nil
  end

  defp next_tile({x, y, dir}, "-") when dir in [:up, :down],
    do: [{x - 1, y, :left}, {x + 1, y, :right}]

  defp next_tile({x, y, dir}, "|") when dir in [:left, :right],
    do: [{x, y - 1, :up}, {x, y + 1, :down}]

  defp next_tile({x, y, :up}, "/"), do: {x + 1, y, :right}
  defp next_tile({x, y, :down}, "/"), do: {x - 1, y, :left}
  defp next_tile({x, y, :left}, "/"), do: {x, y + 1, :down}
  defp next_tile({x, y, :right}, "/"), do: {x, y - 1, :up}
  defp next_tile({x, y, :up}, "\\"), do: {x - 1, y, :left}
  defp next_tile({x, y, :down}, "\\"), do: {x + 1, y, :right}
  defp next_tile({x, y, :left}, "\\"), do: {x, y - 1, :up}
  defp next_tile({x, y, :right}, "\\"), do: {x, y + 1, :down}

  defp next_tile({x, y, :up}, _), do: {x, y - 1, :up}
  defp next_tile({x, y, :down}, _), do: {x, y + 1, :down}
  defp next_tile({x, y, :left}, _), do: {x - 1, y, :left}
  defp next_tile({x, y, :right}, _), do: {x + 1, y, :right}
end
