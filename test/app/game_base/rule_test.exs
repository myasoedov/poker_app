defmodule Poker.GameBase.RuleTest do
  use ExUnit.Case

  alias Poker.GameBase.Rule
  alias Poker.Notation.Short
  alias Poker.GameBase.Rule.{
    HighCard,
    Pair,
    TwoPairs,
    ThreeOfAKind,
    Straight,
    Flush,
    FullHouse,
    FourOfAKind,
    StraightFlush
  }

  import Mox

  defdelegate parse(line), to: Short

  @rule_by_asc_priority ~w(
    high_card
    pair
    two_pairs
    three_of_a_kind
    straight
    flush
    full_house
    four_of_a_kind
    straight_flush
  )a

  @comparator_table %{
    high_card: HighCard,
    pair: Pair,
    two_pairs: TwoPairs,
    three_of_a_kind: ThreeOfAKind,
    straight: Straight,
    flush: Flush,
    full_house: FullHouse,
    four_of_a_kind: FourOfAKind,
    straight_flush: StraightFlush
  }

  defmock(ComparatorMock, for: Poker.GameBase.Rule.Behaviour)
  setup :verify_on_exit!

  setup do
    on_exit &Poker.Overridable.reset/0

    :ok
  end

  describe "detect" do
    [
      {"4C AS 5D 3H 8D", :high_card},
      {"TD QH QS AC 8C", :pair},
      {"5H 6S 5D TC 6D", :two_pairs},
      {"2D 5S 2C TC 2H", :three_of_a_kind},
      {"5D 2S 3H 4C 6D", :straight},
      {"KD TD 4D 2D 9D", :flush},
      {"8D TS TH 8C TC", :full_house},
      {"AD 5D 5H 5S 5C", :four_of_a_kind},
      {"TC 8C 9C QC JC", :straight_flush}
    ]
    |> Enum.each(fn {line, expectation} ->
      test "returns #{expectation} for #{line}" do
        {:ok, line} = parse(unquote(line))

        assert unquote(expectation) == Rule.detect(line)
      end
    end)
  end

  describe "compare" do
    Iteration.run(@rule_by_asc_priority, fn current, tail ->
      Enum.each(tail, fn next ->
        test "returns correct comparison between #{current} and #{next}" do
          assert {:lt, {:rule, next}} = Rule.compare(unquote(current), unquote(next))
          assert {:gt, {:rule, next}} = Rule.compare(unquote(next), unquote(current))
          assert :eq = Rule.compare(unquote(current), unquote(current))
        end
      end)
    end)
  end

  describe "compare_by_rule" do
    @comparator_table
    |> Enum.each(fn {rule, comparator} ->
      test "calls comparator for #{rule}" do
        Poker.Overridable.replace(unquote(comparator), ComparatorMock)

        line1 = "abc"
        line2 = "cdf"

        expect(ComparatorMock, :compare, fn rec1, rec2 ->
          assert rec1 == line1
          assert rec2 == line2

          :comparator_result
        end)

        assert :comparator_result == Rule.compare_by_rule(unquote(rule), line1, line2)
      end
    end)
  end

  describe "to_string" do
    @rule_by_asc_priority
    |> Enum.each(fn rule ->
      test "returns non empty string for #{rule}" do
        assert name = Rule.to_string(unquote(rule))

        assert String.length(name) > 3
      end
    end)
  end
end
