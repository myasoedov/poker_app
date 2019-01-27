defmodule Poker.GameBase.Rule.HighCardTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.HighCard
  defdelegate parse(line), to: Poker.Notation.Short

  [
    {"2S 3H 6D TS 9H", "4D 5H 2S 9C TC", {:gt, {:card, {6, :diamonds}}}},
    {"5D 3H 2S 9C TC", "2S 4H 5D TS 9H", {:lt, {:card, {4, :hearts}}}},
    {"5D 3H 2S 9C TC", "5D 3H 2S 9C TC", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
