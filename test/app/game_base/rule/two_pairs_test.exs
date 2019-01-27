defmodule Poker.GameBase.Rule.TwoPairsTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.TwoPairs
  defdelegate parse(line), to: Poker.Notation.Short

  [
    # by highest pair
    {"3S 3H 6D TS 6H", "2D 2H 5S 7C 5C", {:gt, {:card, {6, :hearts}}}},
    {"5S 5H 6D TS 6H", "7D 2H 7S 2C TC", {:lt, {:card, {7, :spades}}}},
    # by another pair
    {"3S 3H 6D TS 6H", "2D 2H 6S 7C 6C", {:gt, {:card, {3, :hearts}}}},
    {"3S 3H 6D 6S 9H", "6D 4H 6S 9C 4C", {:lt, {:card, {4, :clubs}}}},
    # by high card
    {"3S 3H 6D AS 6H", "3S 3H 6D TS 6H", {:gt, {:card, {:ace, :spades}}}},
    {"6D 4H 6S 9C 4C", "6D 4H 6S JC 4C", {:lt, {:card, {:jack, :clubs}}}},
    {"7D 2H 7S 2C TD", "7D 2H 7S 2C TC", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
