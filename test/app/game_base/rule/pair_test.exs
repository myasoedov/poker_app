defmodule Poker.GameBase.Rule.PairTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.Pair
  defdelegate parse(line), to: Poker.Notation.Short

  [
    # by pair
    {"3S 3H 6D TS 9H", "2D 2H 5S 9C TC", {:gt, {:card, {3, :hearts}}}},
    {"5S 5H 6D TS 9H", "7D 2H 7S 9C TC", {:lt, {:card, {7, :spades}}}},
    # by high card
    {"2S 4H 5D TS 5H", "5D 3H 2S 5C TC", {:gt, {:card, {4, :hearts}}}},
    {"2S 6H 5D TS 5H", "5D 7H 2S 5C TC", {:lt, {:card, {7, :hearts}}}},
    {"5D 3H 5S 9C TC", "5D 3H 5S 9C TC", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
