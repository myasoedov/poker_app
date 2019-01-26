defmodule Poker.GameBase.Rule.ThreeOfAKind do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  @behaviour Behaviour

  def compare(cards1, cards2) do
    {pair1, _left1} = CardsList.take_same_value_trinity(cards1)
    {pair2, _left2} = CardsList.take_same_value_trinity(cards2)

    case Card.compare_value(hd(pair1), hd(pair2)) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end
end
