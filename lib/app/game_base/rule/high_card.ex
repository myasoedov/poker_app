defmodule Poker.GameBase.Rule.HighCard do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList

  @behaviour Behaviour

  def compare(cards1, cards2) do
    case CardsList.compare(cards1, cards2) do
      :eq -> :eq
      {:gt, card} -> {:gt, {:card, card}}
      {:lt, card} -> {:lt, {:card, card}}
    end
  end
end
