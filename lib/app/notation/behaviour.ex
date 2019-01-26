defmodule Poker.Notation.Behaviour do
  alias Poker.GameBase.CardList

  @type error_reason() :: term() | {term(), any()}

  @callback parse(String.t()) :: {:ok, CardList.t()} |
                                 {:error, error_reason()}
end
