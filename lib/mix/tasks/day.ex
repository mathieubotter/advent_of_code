defmodule Mix.Tasks.Day do
  @shortdoc "Start a new day of solving Advent of Code."

  @moduledoc """
  Run an Advent of Code solution.

  The format is:
  ```console
  $ mix day <day> [--year <year>] [--part <part>] [-b]
  ```
  """

  use Mix.Task

  @switches [
    year: :string,
    part: :string,
    bench: :boolean
  ]

  @aliases [
    y: :year,
    p: :part,
    b: :bench
  ]

  def run(args) do
    {opts, parsed} = OptionParser.parse!(args, switches: @switches, aliases: @aliases)

    day = parse_day(parsed)
    year = Keyword.get(opts, :year, current_year())
    part = parse_part(Keyword.get(opts, :part, "1"))
    benchmark? = Keyword.get(opts, :bench, false)

    input = AdventOfCode.Input.get!(day, year)
    module = module(day, year)

    if benchmark? do
      run_benchmark(day, module, part, input)
    else
      run_solution(day, module, part, input)
    end
  end

  defp run_benchmark(day, module, part, input) do
    Benchee.run(%{
      "Day #{day} #{part}" => fn -> apply(module, part, [input]) end
    })
  end

  defp run_solution(day, module, part, input) do
    result = apply(module, part, [input])

    IO.puts([
      "[Day #{day}] Answer #{part}: ",
      IO.ANSI.yellow(),
      inspect(result),
      IO.ANSI.default_color()
    ])
  end

  defp module(day, year) do
    day = String.pad_leading(day, 2, "0")
    module_name = "Elixir.AdventOfCode.Year#{year}.Day#{day}"

    try do
      String.to_existing_atom(module_name)
    rescue
      ArgumentError ->
        Mix.raise("Module #{module_name} does not exist.")
    end
  end

  defp parse_day([day | _]) when is_binary(day) do
    case Integer.parse(day) do
      {n, ""} when n in 1..25 -> to_string(n)
      _ -> Mix.raise("Invalid day: #{day}. Must be an integer between 1 and 25.")
    end
  end

  defp parse_day([]) do
    Mix.raise("Missing day argument.")
  end

  defp parse_day(_) do
    Mix.raise("Too many arguments. Expected: mix day <day> [options]")
  end

  defp parse_part(part) when part in ["1", "2"] do
    String.to_atom("part#{part}")
  end

  defp parse_part(part) do
    Mix.raise("Invalid part: #{part}. Must be '1' or '2'.")
  end

  defp current_year do
    Date.utc_today().year
  end
end
