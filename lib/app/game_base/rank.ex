defmodule Poker.GameBase.Rank do
  @moduledoc """
    Rank ability
  """

  alias Poker.GameBase.Card
  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Rule

  import Poker, only: [dep: 1]

  @type diff() :: :lt | :gt
  @type diff_reason() :: {:rule, Rule.t()} | {:card, Card.t()}
  @type comparison() :: :eq | {diff(), diff_reason()}

  @spec compare(CardsList.t(), CardsList.t()) :: comparison()
  def compare(cards1, cards2) do
    rule1 = dep(Rule).detect(cards1)
    rule2 = dep(Rule).detect(cards2)

    if rule1 == rule2 do
      dep(Rule).compare_by_rule(rule1, cards1, cards2)
    else
      dep(Rule).compare(rule1, rule2)
    end
  end
end
