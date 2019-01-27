defmodule Poker.GameBase.Rule.ThreeOfAKind do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  @behaviour Behaviour

  def compare(cards1, cards2) do
    {trinity1, _left1} = CardsList.take_group_of(cards1, 3, &Card.value/1)
    {trinity2, _left2} = CardsList.take_group_of(cards2, 3, &Card.value/1)

    case Card.compare_value(hd(trinity1), hd(trinity2)) do
      :eq -> :eq
      :gt -> {:gt, {:card, hd(trinity1)}}
      :lt -> {:lt, {:card, hd(trinity2)}}
    end
  end
end
