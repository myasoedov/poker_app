defmodule Poker.GameBase.Card do
  @moduledoc """
    Card type with utils
  """

  @type value :: 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | :jack | :queen | :king | :ace
  @type suit :: :clubs | :diamonds | :hearts | :spaces
  @type integer_rate :: integer()
  @type t :: {value(), suit()}
  @type cards_list :: list(t())

  @type comparison() :: :lt | :gt | :eq

  @spec create(value(), suit()) :: t()
  def create(value, suit), do: {value, suit}

  @spec suit(t()) :: suit()
  def suit({_value, suit}), do: suit

  @spec value(t()) :: value()
  def value({value, _suit}), do: value

  @spec compare_value(t(), t()) :: comparison()
  def compare_value(card1, card2) do
    priority1 = to_value_priority(card1)
    priority2 = to_value_priority(card2)

    cond do
      priority1 > priority2 -> :gt
      priority1 < priority2 -> :lt
      true -> :eq
    end
  end

  @spec to_value_priority(value() | t()) :: integer_rate()
  def to_value_priority({value, _suit}), do: to_value_priority(value)
  def to_value_priority(value) when is_integer(value), do: value
  def to_value_priority(:jack), do: 11
  def to_value_priority(:queen), do: 12
  def to_value_priority(:king), do: 13
  def to_value_priority(:ace), do: 14
end
