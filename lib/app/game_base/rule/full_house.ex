defmodule Poker.GameBase.Rule.FullHouse do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  @behaviour Behaviour

  def compare(cards1, cards2) do
    {trinity1, _left1} = CardsList.take_same_value_trinity(cards1)
    {trinity2, _left2} = CardsList.take_same_value_trinity(cards2)

    case Card.compare_value(hd(trinity1), hd(trinity2)) do
      :eq -> :eq
      {result, card} -> {result, {:card, card}}
    end
  end
end
