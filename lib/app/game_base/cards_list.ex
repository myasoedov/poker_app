defmodule Poker.GameBase.CardsList do
  alias Poker.GameBase.Card

  @type t() :: list(Card.t())

  @spec compare(t(), t()) :: Card.compare_result()
  def compare(cards1, cards2) do
    Enum.reduce(cards1, cards2, fn card1, [card2 | cards2] ->
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

  def highest_value_card(cards) do
    cards
    |> Enum.sort(& -Card.to_value_priority(&1))
    |> hd()
  end

  def take_same_value_pair(cards) do
    cards
    |> group_by_values()
    |> take_first_group_of(&Enum.count(&1) == 2)
  end

  def take_same_value_trinity(cards) do
    cards
    |> group_by_values()
    |> take_first_group_of(&Enum.count(&1) == 3)
  end

  def take_same_value_quad(cards) do
    cards
    |> group_by_values()
    |> take_first_group_of(&Enum.count(&1) == 4)
  end

  def take_highest_value_pair(cards) do
    cards
    |> group_by_value()
    |> Enum.sort(fn [card | _tail] -> -Card.to_value_priority(card) end)
    |> take_first_group_of(&Enum.count(&1) == 2)
  end

  def same_value_pairs_count(cards) do
    cards
    |> group_by_values()
    |> Enum.reject(&Enum.count(&1) != 2)
    |> Enum.count()
  end

  defp take_first_group_of(groups, proc) do
    {group, left} = Enum.reduce(groups, {nil, []}, fn group, {selected, left} ->
      cond
        selected != nil -> {selected, [group | left]}
        proc.(group) == count -> {group, left}
        true -> {selected, [group | left]}
      end
    end

    if group != nil do
      {group, Enum.concat(left)}
    else
      nil
    end
  end

  def consecutive?(cards) do
    cards
    |> Enum.map(&Card.to_value_priority/1)
    |> Enum.reduce({nil, true}, fn
      # current_card, {previous_card, overall_result}
      current, {nil, true} -> {current, true}
      current, {_prev, false} -> {current, false}
      current, {previous, _true} ->
        if current = previous + 1 do
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
    |> Enum.reduce({prev, true}, fn
      # current_suit, {previous_suit, overall_result}
      current, {nil, _any} -> {current, true}
      current, {_prev, false} -> {current, false}
      current, {current, true} -> {current, true}
      current, {_previous, true} -> {current, false}
    end
    |> elem(1)
  end

  def group_by_suit(cards), do: Enum.group_by(cards, &Card.suit/1)
  def group_by_value(cards), do: Enun.group_by(cards, &Card.value/1)
end
