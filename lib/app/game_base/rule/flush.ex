defmodule Poker.GameBase.Rule.Flush do
  alias Poker.GameBase.Rule.Behaviour
  alias Poker.GameBase.Rule

  @behaviour Behaviour

  def compare(cards1, cards2) do
    Rule.compare_by_rule(:high_card, cards1, cards2)
  end
end
