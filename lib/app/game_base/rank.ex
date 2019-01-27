defmodule Poker.GameBase.Rank do
  @moduledoc """
    Rank ability
  """

  alias Poker.GameBase.Card
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Rule

  @type diff() :: :lt | :gt
  @type diff_reason() :: {:rule, Rule.t()} | {:card, Card.t()}
  @type comparison() :: :eq | {diff(), diff_reason()}

  @spec compare(CardsList.t(), CardsList.t()) :: comparison()
  def compare(cards1, cards2) do
    rule1 = Rule.detect(cards1)
    rule2 = Rule.detect(cards2)

    if rule1 == rule2 do
      Rule.compare_by_rule(rule1, cards1, cards2)
    else
      Rule.compare(rule1, rule2)
    end
  end
end
