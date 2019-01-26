defmodule Poker.GameBase.Rule.Straight do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  @behaviour Behaviour

  def compare(cards1, cards2) do
    highest1 = CardsList.highest_value_card(cards1)
    highest2 = CardsList.highest_value_card(cards2)

    case Card.compare_value(highest1, highest2) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end
end
