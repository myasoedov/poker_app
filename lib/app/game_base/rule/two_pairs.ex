defmodule Poker.GameBase.Rule.TwoPairs do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card
  alias Poker.GameBase.Rule

  @behaviour Behaviour

  def compare(cards1, cards2) do
    {pair1, left1} = CardsList.take_highest_pair(cards1)
    {pair2, left2} = CardsList.take_highest_pair(cards2)

    case Card.compare_value(hd(pair1), hd(pair2)) do
      :eq -> Rule.compare_by_rule(:pair, left1, left2)
      :gt -> {:gt, {:card, hd(pair1)}}
      :lt -> {:lt, {:card, hd(pair2)}}
    end
  end
end
