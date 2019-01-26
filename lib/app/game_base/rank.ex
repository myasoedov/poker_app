defmodule Poker.GameBase.Rank do
  @moduledoc false
  alias Poker.GameBase.Card
  alias Poker.GameBase.CardsList

  @type t() :: :high_card |
               :pair |
               :two_pairs |
               :three_of_a_kind |
               :straight |
               :flush |
               :full_house |
               :four_of_a_kind |
               :straight_flush

  @type diff() :: :lt | :gt
  @type diff_reason() :: {:rank, t()} | {:card, Card.t()}
  @type compare() :: :eq | {diff(), diff_reason()}

  @rank_by_asc_priority ~w(
    high_card pair
    two_pairs
    three_of_a_kind
    straight
    flush
    full_house
    four_of_a_kind
    straight_flush
  )a

  @spec rank(Card.list()) :: rank()
  def rank(cards) do
    consecutive? = CardsList.consecutive?(cards)
    all_same_suit? = CardsList.all_same_suit?(cards)

    pairs_count = CardList.count_groups_of(cards, 1, &Card.value/1)
    trinity? = CardList.count_groups(cards, 3, &Card.value/1) == 1
    quad? = CardList.count_groups(cards, 4, &Card.value/1) == 1

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

  @spec compare(Card.list(), Card.list()) :: compare()
  def compare_cards(cards1, cards2) do
    rank1 = rank(cards1)
    rank2 = rank(cards2)

    if rank1 == rank2 do
      compare_cards_by_rank(rank1, cards1, cards2)
    else
      compare_rank(rank1, rank2)
    end
  end

  #@spec compare_rank(t(), t()) :: compare()
  defp compare_rank(rank1, rank2) do
    rank_priority1 = rank_to_priority(rank1)
    rank_priority2 = rank_to_priority(rank2)

    cond do
      rank_priority1 > rank_priority2 -> {:gt, {:rank, rank1}}
      rank_priority1 < rank_priority2 -> {:lt, {:rank, rank2}}
      true -> :eq
    end
  end

  defp compare_cards_by_rank(:high_card, cards1, cards2) do
    CardsList.compare(cards1, cards2)
  end

  defp compare_cards_by_rank(:pair, cards1, cards2) do
    {pair1, left1} = CardsList.take_same_value_pair(cards1)
    {pair2, left2} = CardsList.take_same_value_pair(cards2)

    case Card.compare(hd(pair1), hd(pair2)) do
      :eq -> compare_cards_by_rank(:high_card, left1, left2)
      {result, card} -> {result, {:card, card}}
    end
  end

  defp compare_cards_by_rank(:two_pairs, cards1, cards2) do
    {pair1, left1} = CardsList.take_highest_value_pair(cards1)
    {pair2, left2} = CardsList.take_highest_value_pair(cards2)

    case Card.compare(hd(pair1), hd(pair2)) do
      :eq -> compare_cards_by_rank(:pair, left1, left2)
      {result, card} -> {result, {:card, card}}
    end
  end

  defp compare_cards_by_rank(:three_of_a_kind, cards1, cards2) do
    {pair1, left1} = CardsList.take_same_value_trinity(cards1)
    {pair2, left2} = CardsList.take_same_value_trinity(cards2)

    case Card.compare(hd(pair1), hd(pair2)) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end

  defp compare_cards_by_rank(:straight, cards1, cards2) do
    highest1 = CardList.highest_value_card(cards1)
    highest2 = CardList.highest_value_card(cards2)

    case Card.compare_value(highest1, highest2) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end

  defp compare_cards_by_rank(:flush, cards1, cards2) do
    compare_cards_by_rank(:high_card)
  end

  defp compare_cards_by_rank(:full_house, cards1, cards2) do
    {trinity1, left1} = CardsList.take_same_value_trinity(cards1)
    {trinity2, left2} = CardsList.take_same_value_trinity(cards2)

    case Card.compare_value(hd(trinity1), hd(trinity2)) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end

  defp compare_cards_by_rank(:four_of_a_kind, cards1, cards2) do
    {quad1, left1} = CardsList.take_same_value_trinity(cards1)
    {quad2, left2} = CardsList.take_same_value_trinity(cards2)

    case Card.compare_value(hd(quad1), hd(quad2)) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end

  defp compare_cards_by_rank(:straight_flush, cards1, cards2) do
    highest1 = CardList.highest_value_card(cards1)
    highest2 = CardList.highest_value_card(cards2)

    case Card.compare_value(highest1, highest2) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end

  defp rank_to_priority(rank), do: Enum.find_index(@rank_by_asc_priority, &(&1 == rank))
end
