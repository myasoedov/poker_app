defmodule Poker.GameBase.CardsList do
  alias Poker.GameBase.Card

  @type t() :: list(Card.t())

  @spec compare(t(), t()) :: Card.compare_result()
  def compare(cards1, cards2) do
    Enum.reduce_while(cards1, cards2, fn card1, [card2 | cards2] ->
      case Card.compare_value(card1, card2) do
        :gt -> {:halt, {:gt, card1}}
        :lt -> {:halt, {:lt, card2}}
        :eq ->
          if cards2 == [] do
            {:halt, :eq}
          else
            {:cont, cards2}
          end
      end
    end)
  end

  @spec highest_value_card(t()) :: Card.t()
  def highest_value_card(cards) do
    cards
    |> Enum.sort(&Card.to_value_priority(&1) <= Card.to_value_priority(&2))
    |> hd()
  end

  @spec take_same_value_pair(t()) :: {t(), t()}
  def take_same_value_pair(cards) do
    cards
    |> group_by_values()
    |> take_first_group_of(&Enum.count(&1) == 2)
  end

  @spec take_same_value_trinity(t()) :: {t(), t()}
  def take_same_value_trinity(cards) do
    cards
    |> group_by_values()
    |> take_first_group_of(&Enum.count(&1) == 3)
  end

  @spec take_same_value_quad(t()) :: {t(), t()}
  def take_same_value_quad(cards) do
    cards
    |> group_by_values()
    |> take_first_group_of(&Enum.count(&1) == 4)
  end

  @spec take_highest_value_pair(t()) :: t()
  def take_highest_value_pair(cards) do
    cards
    |> group_by_values()
    |> Enum.sort(fn [card | _tail] -> -Card.to_value_priority(card) end)
    |> take_first_group_of(&Enum.count(&1) == 2)
  end

  @spec count_groups_of(t(), integer(), function()) :: integer()
  def count_groups_of(cards, group_length, proc) do
    cards
    |> Enum.group_by(proc)
    |> Map.values()
    |> Enum.reject(&Enum.count(&1) != group_length)
    |> Enum.count()
  end

  def same_value_pairs_count(cards) do
    cards
    |> group_by_values()
    |> Enum.reject(&Enum.count(&1) != 2)
    |> Enum.count()
  end

  def take_first_group_of(groups, proc) do
    {group, left} = Enum.reduce(groups, {nil, []}, fn group, {selected, left} ->
      cond do
        selected != nil -> {selected, [group | left]}
        proc.(group) -> {group, left}
        true -> {selected, [group | left]}
      end
    end)

    if group != nil do
      {group, Enum.concat(left)}
    else
      nil
    end
  end


  def consecutive?(cards) do
    cards
    |> Enum.map(&Card.to_value_priority/1)
    |> Enum.sort()
    |> Enum.reduce({nil, true}, fn
      # current_card, {previous_card, overall_result}
      current, {nil, true} -> {current, true}
      current, {_prev, false} -> {current, false}
      current, {previous, _true} ->
        if current == previous + 1 do
          {current, true}
        else
          {current, false}
        end
    end)
    |> elem(1)
  end

  def all_same_suit?(cards) do
    cards
    |> Enum.map(&Card.suit/1)
    |> Enum.reduce({nil, true}, fn
      # current_suit, {previous_suit, overall_result}
      current, {nil, _any} -> {current, true}
      current, {_prev, false} -> {current, false}
      current, {current, true} -> {current, true}
      current, {_previous, true} -> {current, false}
    end)
    |> elem(1)
  end

  def group_by_suits(cards) do
    cards
    |> Enum.group_by(&Card.suit/1)
    |> Map.values()
  end

  def group_by_values(cards) do
    cards
    |> Enum.group_by(&Card.value/1)
    |> Map.values()
  end
end
