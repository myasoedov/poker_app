defmodule Poker.NotationTest do
  use ExUnit.Case
  import Mox
  import Poker.Overridable

  alias __MODULE__.NotationMock

  defmock(NotationMock, for: Poker.Notation.Behaviour)
  setup :verify_on_exit!

  setup do
    replace(Poker.Notation.Short, NotationMock)

    on_exit &reset/0

    :ok
  end

  test "calls notation implementation" do
    line = "abc"
    expect(NotationMock, :parse, fn received ->
      assert received == line

      :ok
    end)

    Poker.Overridable.get(Poker.Notation.Short)

    assert :ok = Poker.Notation.parse(line)
  end
end
