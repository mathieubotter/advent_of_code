defmodule AdventOfCode.Input do
  @moduledoc """
  Comes from this starter template:
  https://github.com/mhanberg/advent-of-code-elixir-starter/blob/main/lib/advent_of_code/input.ex
  """

  def get!(day, year \\ nil)
  def get!(day, nil), do: get!(day, current_year())

  def get!(day, year) do
    cond do
      in_cache?(day, year) ->
        IO.puts("[Day #{day}] Input from cache...")
        from_cache!(day, year)

      allow_network?() ->
        download!(day, year)

      true ->
        IO.puts("""
        #{IO.ANSI.red()}No inputs available for day #{day} of year #{year}.
        """)
    end
  end

  defp current_year do
    date = Date.utc_today()
    date.year
  end

  defp cache_dir do
    [File.cwd!(), "/.cache"]
    |> Path.join()
    |> Path.expand()
  end

  defp cache_path(day, year) do
    [cache_dir(), "/#{year}/#{day}.in"]
    |> Path.join()
  end

  defp in_cache?(day, year),
    do: File.exists?(cache_path(day, year))

  defp from_cache!(day, year),
    do: File.read!(cache_path(day, year))

  defp store_in_cache!(day, year, input) do
    path = cache_path(day, year)
    :ok = path |> Path.dirname() |> File.mkdir_p!()
    :ok = File.write!(path, input)
  end

  defp download!(day, year) do
    IO.puts("Downloading input...")

    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    base_url = "https://adventofcode.com"
    url = "#{base_url}/#{year}/day/#{day}/input"

    {:ok, {{~c"HTTP/1.1", 200, ~c"OK"}, _, input}} =
      :httpc.request(:get, {url, headers()}, [], [])

    IO.puts("Downloaded!")

    store_in_cache!(day, year, input)
    IO.puts("Cached!")

    to_string(input)
  end

  defp headers,
    do: [{~c"cookie", String.to_charlist("session=" <> Keyword.get(config(), :session_cookie))}]

  defp config,
    do: Application.fetch_env!(:advent_of_code, __MODULE__)

  defp allow_network?, do: true
end
