defmodule Poker.Notation do
  alias Poker.Notation.Short

  def parse(line), do: Short.parse(line)
end
