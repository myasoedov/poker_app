defmodule Poker.GameBase.CardsList do
  @moduledoc """
    Cards list math
  """

  alias Poker.GameBase.Card

  @type t() :: list(Card.t())

  @doc """
    Compares cards lists
  """
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

  @doc """
    Returns highest value card from list
  """
  @spec highest_card(t()) :: Card.t()
  def highest_card(cards) do
    cards
    |> Enum.sort(&Card.to_value_priority(&1) <= Card.to_value_priority(&2))
    |> hd()
  end

  @doc """
    Returns first group with `group_length` elements grouped by `group_proc`
  """
  @spec take_group_of(t(), integer(), function()) :: integer()
  def take_group_of(cards, group_length, group_proc) do
    cards
    |> Enum.group_by(group_proc)
    |> Map.values()
    |> first_group_with(&Enum.count(&1) == group_length)
  end

  @doc """
    Returns pair with highest value card
  """
  @spec take_highest_pair(t()) :: t()
  def take_highest_pair(cards) do
    cards
    |> Enum.group_by(&Card.value/1)
    |> Map.values()
    |> Enum.sort(fn cards1, cards2 ->
      card1 = highest_card(cards1)
      card2 = highest_card(cards2)

      Card.to_value_priority(card1) < Card.to_value_priority(card2)
    end)
    |> first_group_with(&Enum.count(&1) == 2)
  end

  @doc """
    Calculates count of group of `group_length` elements grouped by `group_proc`
  """
  @spec count_groups_of(t(), integer(), function()) :: integer()
  def count_groups_of(cards, group_length, group_proc) do
    cards
    |> Enum.group_by(group_proc)
    |> Map.values()
    |> Enum.reject(&Enum.count(&1) != group_length)
    |> Enum.count()
  end

  @doc """
    Checks if cards list contains consecutive values
  """
  @spec consecutive?(t()) :: boolean()
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

  @doc """
    Checks if cards from the list have the same suit
  """
  @spec all_same_suit?(t()) :: boolean()
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

  defp first_group_with(groups, cond_proc) do
    {group, left} = Enum.reduce(groups, {nil, []}, fn group, {selected, left} ->
      cond do
        selected != nil -> {selected, [group | left]}
        cond_proc.(group) -> {group, left}
        true -> {selected, [group | left]}
      end
    end)

    if group != nil do
      {group, Enum.concat(left)}
    else
      nil
    end
  end
end
