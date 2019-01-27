defmodule Poker.GameBase.Rule.FlushTest do
  use ExUnit.Case

  defdelegate compare(cards1, cards2), to: Poker.GameBase.Rule.Flush
  defdelegate parse(line), to: Poker.Notation.Short

  [
    {"TD JD 5D 2D 8D", "2S 4S 3S JS TS", {:gt, {:card, {8, :diamonds}}}},
    {"2S 4S 3S JS TS", "TD JD 5D 2D 8D", {:lt, {:card, {8, :diamonds}}}},
    {"TD JD 5D 2D 8D", "TH JH 5H 2H 8H", :eq}
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "compares correctly #{line1} and #{line2}" do
      {:ok, cards1} = parse(unquote(line1))
      {:ok, cards2} = parse(unquote(line2))

      assert unquote(expectation) == compare(cards1, cards2)
    end
  end)
end
