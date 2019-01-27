defmodule Poker.GameBase.Rule.StraightTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.Straight
  defdelegate parse(line), to: Poker.Notation.Short

  [
    {"JD TD 7D 8D 9D", "4S 3S 5S 6S 7S", {:gt, {:card, {:jack, :diamonds}}}},
    {"3S 6S 4S 5S 7S", "QH TH JH KH 9H", {:lt, {:card, {:king, :hearts}}}},
    {"3S 6S 4S 5S 7S", "6D 3D 4D 5D 7D", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
