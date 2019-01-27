defmodule Poker.GameBase.Rule.FourOfAKind do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  @behaviour Behaviour

  def compare(cards1, cards2) do
    {quad1, _left1} = CardsList.take_group_of(cards1, 4, &Card.value/1)
    {quad2, _left2} = CardsList.take_group_of(cards2, 4, &Card.value/1)

    case Card.compare_value(hd(quad1), hd(quad2)) do
      :eq -> :eq
      :gt -> {:gt, {:card, hd(quad1)}}
      :lt -> {:lt, {:card, hd(quad2)}}
    end
  end
end
