defmodule Poker.GameBase.Rule do
  @moduledoc """
    Rank rule utils
  """

  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card
  alias Poker.GameBase.Rank
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

  import Poker.Overridable, only: [overridable: 1]

  @type t() :: :high_card |
               :pair |
               :two_pairs |
               :three_of_a_kind |
               :straight |
               :flush |
               :full_house |
               :four_of_a_kind |
               :straight_flush

  @default_comparator_table %{
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

  @names %{
    high_card: "High card",
    pair: "Pair",
    two_pairs: "Two pairs",
    three_of_a_kind: "Three of a kind",
    straight: "Straight",
    flush: "Flush",
    full_house: "Full house",
    four_of_a_kind: "Four of a kind",
    straight_flush: "Straight flush"
  }

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

  @spec detect(CardsList.t()) :: t()
  def detect(cards) do
    consecutive? = CardsList.consecutive?(cards)
    all_same_suit? = CardsList.all_same_suit?(cards)

    pairs_count = CardsList.count_groups_of(cards, 2, &Card.value/1)
    trinity? = CardsList.count_groups_of(cards, 3, &Card.value/1) == 1
    quad? = CardsList.count_groups_of(cards, 4, &Card.value/1) == 1

    cond do
      consecutive? && all_same_suit? -> :straight_flush
      quad? -> :four_of_a_kind
      trinity? && pairs_count == 1 -> :full_house
      all_same_suit? -> :flush
      consecutive? -> :straight
      trinity? -> :three_of_a_kind
      pairs_count == 2 -> :two_pairs
      pairs_count == 1 -> :pair
      true -> :high_card
    end
  end

  @spec compare(t(), t()) :: Rank.comparison()
  def compare(rule1, rule2) do
    rule_priority1 = rule_to_priority(rule1)
    rule_priority2 = rule_to_priority(rule2)

    cond do
      rule_priority1 > rule_priority2 -> {:gt, {:rule, rule1}}
      rule_priority1 < rule_priority2 -> {:lt, {:rule, rule2}}
      true -> :eq
    end
  end

  @spec compare_by_rule(t(), CardsList.t(), CardsList.t()) :: Rank.comparison()
  def compare_by_rule(rule, cards1, cards2) do
    get_comparator(rule).compare(cards1, cards2)
  end

  @spec to_string(t()) :: String.t()
  def to_string(rule), do: @names[rule]

  defp get_comparator(rule) do
    @default_comparator_table
    |> Map.fetch!(rule)
    |> overridable()
  end

  defp rule_to_priority(rule), do: Enum.find_index(@rule_by_asc_priority, &(&1 == rule))
end
