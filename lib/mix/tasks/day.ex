defmodule Mix.Tasks.Day do
  @shortdoc "Start a new day of solving Advent of Code."

  use Mix.Task

  @switches [part: :string]

  def run(args) do
    {opts, [day]} = OptionParser.parse!(args, switches: @switches)
    year = 2023
    part = part(Keyword.get(opts, :part, "1"))

    input = AdventOfCode.Input.get!(day, year)

    if Enum.member?(args, "-b") do
      Benchee.run(%{part => fn -> solve(day, year, part, input) end})
    else
      result = solve(day, year, part, input)

      IO.puts(
        "[Day #{day}] Answer #{part}: #{IO.ANSI.yellow()}#{result}#{IO.ANSI.default_color()}"
      )
    end
  end

  defp solve(day, year, fun, input), do: apply(module(day, year), fun, [input])

  defp module(day, year),
    do:
      String.to_existing_atom(
        "Elixir.AdventOfCode.Year#{year}.Day#{day |> String.pad_leading(2, "0")}"
      )

  defp part(number), do: String.to_atom("part" <> number)
end
