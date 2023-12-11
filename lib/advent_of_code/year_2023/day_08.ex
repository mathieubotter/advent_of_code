defmodule AdventOfCode.Year2023.Day08 do
  def part1(input) do
    parse(input)
    |> navigate(&Kernel.==/2, "AAA", "ZZZ")
    |> List.first()
  end

  def part2(input) do
    parse(input)
    |> navigate(&String.ends_with?/2, "A", "Z")
    |> Enum.reduce(1, fn x, y -> lcm(x, y) end)
  end

  defp parse(input) do
    [instructions, network] = String.split(input, "\n\n")
    {instructions, parse_nodes(network)}
  end

  defp parse_nodes(network) do
    String.split(network, "\n", trim: true)
    |> Enum.map(&parse_node/1)
  end

  defp parse_node(<<pos::binary-3, " = (", left::binary-3, ", ", right::binary-3, ")">>),
    do: {pos, left, right}

  defp navigate({instructions, nodes}, fun, first_pos, last_pos) do
    instructions = String.graphemes(instructions)

    nodes
    |> Enum.filter(&fun.(node_pos(&1), first_pos))
    |> Enum.map(&node_index(nodes, node_pos(&1)))
    |> Enum.map(&navigate(nodes, instructions, &1, fun, last_pos))
  end

  defp navigate(nodes, instructions, index, fun, last_pos, steps \\ 0) do
    instructions
    |> Enum.reduce_while({index, steps}, fn instr, {index, steps} ->
      {label, left, right} = Enum.at(nodes, index)

      if fun.(label, last_pos) do
        {:halt, steps}
      else
        next_index =
          if instr == "L",
            do: node_index(nodes, left),
            else: node_index(nodes, right)

        {:cont, {next_index, steps + 1}}
      end
    end)
    |> case do
      {next_index, steps} ->
        navigate(nodes, instructions, next_index, fun, last_pos, steps)

      result ->
        result
    end
  end

  defp node_index(nodes, pos), do: Enum.find_index(nodes, &(node_pos(&1) == pos))
  defp node_pos({pos, _, _}), do: pos

  # Calculate the least common multiple of two numbers
  defp lcm(x, y), do: div(x * y, Integer.gcd(x, y))
end
