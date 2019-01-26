defmodule Poker.GameBase.Rule.Behaviour do
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Rank

  @callback compare(CardsList.t(), CardsList.t()) :: Rank.comparison()
end
