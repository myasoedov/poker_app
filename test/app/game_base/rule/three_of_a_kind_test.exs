defmodule Poker.GameBase.Rule.ThreeOfAKindTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.ThreeOfAKind
  defdelegate parse(line), to: Poker.Notation.Short

  [
    # by pair
    {"3S 3H 6D 3S 9H", "2D 2H 5S 2C TC", {:gt, {:card, {3, :spades}}}},
    {"5S 5H 6D TS 5H", "7D 7H 7S 9C TC", {:lt, {:card, {7, :spades}}}},
    {"5S 5H 6D TS 5H", "5S 5H 6D KS 5H", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
