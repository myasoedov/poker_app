defmodule Poker.Notation do
  alias Poker.Notation.Short

  import Poker.Overridable

  def parse(line), do: overridable(Short).parse(line)
end
