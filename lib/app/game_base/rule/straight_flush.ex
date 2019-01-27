defmodule Poker.GameBase.Rule.StraightFlush do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  @behaviour Behaviour

  def compare(cards1, cards2) do
    highest1 = CardsList.highest_card(cards1)
    highest2 = CardsList.highest_card(cards2)

    case Card.compare_value(highest1, highest2) do
      :eq -> :eq
      :gt -> {:gt, {:card, highest1}}
      :lt -> {:lt, {:card, highest2}}
    end
  end
end
