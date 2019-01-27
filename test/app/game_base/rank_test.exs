defmodule Poker.GameBase.RankTest do
  use ExUnit.Case

  alias Poker.GameBase.Rank
  alias Poker.Notation.Short

  defdelegate parse(line), to: Short

  [
    {"2H 3D 5S 9C KD", "2C 3H 4S 8C AH", {:lt, {:card, {:ace, :hearts}}}},
    {"2C 3H 4S 8C AH", "2H 3D 5S 9C KD", {:gt, {:card, {:ace, :hearts}}}},
    {"2H 4S 4C 3D 4H", "2S 8S AS QS 3S", {:lt, {:rule, :flush}}},
    {"2S 8S AS QS 3S", "2H 4S 4C 3D 4H", {:gt, {:rule, :flush}}},
    {"2C 3H 4S 8C KH", "2H 3D 5S 9C KD", {:lt, {:card, {9, :clubs}}}},
    {"2H 3D 5S 9C KD", "2C 3H 4S 8C KH", {:gt, {:card, {9, :clubs}}}},
    {"2H 3D 5S 9C KD", "2D 3H 5C 9S KH", :eq},
  ]
  |> Enum.each(fn {line1, line2, expectation} ->
    test "returns correct result for #{line1} and #{line2}" do
      {:ok, list1} = parse(unquote(line1))
      {:ok, list2} = parse(unquote(line2))

      assert unquote(expectation) == Rank.compare(list1, list2)
    end
  end)
end
