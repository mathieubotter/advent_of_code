defmodule AdventOfCode.Year2023.Day07 do
  @cards ~w(2 3 4 5 6 7 8 9 T J Q K A)
  @cards_with_joker ~w(J 2 3 4 5 6 7 8 9 T Q K A)
  @ranks ~w(high_card one_pair two_pair three_of_kind full_house four_of_kind five_of_kind)a

  def part1(input) do
    parse(input)
    |> Enum.sort(&compare_rank/2)
    |> Enum.chunk_by(&elem(&1, 2))
    |> Enum.map(fn hands -> Enum.sort(hands, &compare_cards(&1, &2, @cards)) end)
    |> List.flatten()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, bid, _}, i}, total -> total + bid * i end)
  end

  def part2(input) do
    parse(input, true)
    |> Enum.sort(&compare_rank/2)
    |> Enum.chunk_by(&elem(&1, 2))
    |> Enum.map(fn hands -> Enum.sort(hands, &compare_cards(&1, &2, @cards_with_joker)) end)
    |> List.flatten()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, bid, _}, i}, total -> total + bid * i end)
  end

  defp parse(input, with_joker \\ false) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_hand_bid(&1, with_joker))
  end

  defp parse_hand_bid(line, with_joker) do
    [hand, bid] = String.split(line, " ")

    bid = String.to_integer(bid)

    rank =
      if with_joker,
        do: evaluate_rank(hand),
        else: evaluate_rank_with_joker(hand)

    {hand, bid, rank}
  end

  defp evaluate_rank(hand) do
    hand
    |> to_charlist()
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> rank()
  end

  defp evaluate_rank_with_joker(hand) do
    {jokers, cards} =
      hand
      |> to_charlist()
      |> Enum.frequencies()
      |> Map.pop(?J, 0)

    cards
    |> Map.values()
    |> Enum.sort(:desc)
    |> insert_or_update(jokers)
    |> rank()
  end

  defp rank([5]), do: :five_of_kind
  defp rank([4, _]), do: :four_of_kind
  defp rank([3, 2]), do: :full_house
  defp rank([3, 1, _]), do: :three_of_kind
  defp rank([2, 2, _]), do: :two_pair
  defp rank([2, 1, 1, _]), do: :one_pair
  defp rank(_), do: :high_card

  defp compare_rank(hand1, hand2) do
    hand1_rank = Enum.find_index(@ranks, &(&1 == elem(hand1, 2)))
    hand2_rank = Enum.find_index(@ranks, &(&1 == elem(hand2, 2)))
    hand2_rank > hand1_rank
  end

  defp compare_cards(hand1, hand2, card_values) do
    hand1_cards = String.graphemes(elem(hand1, 0))
    hand2_cards = String.graphemes(elem(hand2, 0))

    0..4
    |> Enum.reduce_while(false, fn n, _acc ->
      card1 = Enum.at(hand1_cards, n) |> card_value(card_values)
      card2 = Enum.at(hand2_cards, n) |> card_value(card_values)

      if card2 == card1,
        do: {:cont, false},
        else: {:halt, card2 > card1}
    end)
  end

  defp card_value(card, card_values), do: Enum.find_index(card_values, &(&1 == card))

  defp insert_or_update([], value), do: [value]
  defp insert_or_update(list, value), do: List.update_at(list, 0, &(&1 + value))
end
