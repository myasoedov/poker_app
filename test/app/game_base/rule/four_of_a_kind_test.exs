defmodule Poker.GameBase.Rule.FourOfAKindTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.FourOfAKind
  defdelegate parse(line), to: Poker.Notation.Short

  [
    {"TD TS 5D TD TD", "9S 4H 9C 9D 9S", {:gt, {:card, {10, :diamonds}}}},
    {"9S 4H 9C 9D 9S", "TD QS QD QD QD", {:lt, {:card, {:queen, :diamonds}}}},
    {"TD JD TD TD TD", "TH TH 5H TH TH", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
