defmodule Poker.GameBase.Hand do
  @type t() :: %__MODULE__{}

  alias Poker.GameBase.Card

  defstruct cards: [],
            name: nil

  @spec create(String.t(), Card.list(), count()) :: {:ok, t()} | {:error, term()}
  def create(name, cards, count) do
    cond do
      Enum.count(cards) != count -> {:error, :bad_cards_number}
      String.length(name) < @min_name_length -> {:error, :name_is_to_short}
      true -> {:ok, %__MODULE__{cards: cards, name: name}}
    end
  end
end
