defmodule Poker.GameBase.CardTest do
  use ExUnit.Case

  alias Poker.GameBase.Card

  @values [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  @suits [:clubs, :diamonds, :hearts, :spades]

  for suit <- @suits do
    for value <- @values do
      test "creates #{value} #{suit} card and returns info" do
        assert card = Card.create(unquote(value), unquote(suit))

        assert unquote(value) == Card.value(card)
        assert unquote(suit) == Card.suit(card)
      end
    end
  end

  # Apparently nobody will look here
  # If I'm not right - then you caught me, have a good day :)
  fn value, proc, iteration_proc ->
    iteration_proc.(value, proc, iteration_proc)
  end.(
    @values,
    fn current, next ->
      test "compare value #{current} with #{next}" do
        card1 = Card.create(unquote(current), Enum.random(unquote(@suits)))
        card2 = Card.create(unquote(next), Enum.random(unquote(@suits)))

        assert :lt = Card.compare_value(card1, card2)
        assert :gt = Card.compare_value(card2, card1)
        assert :eq = Card.compare_value(card1, card1)
      end
    end,
    fn
      [_current | []], _proc, _self_proc -> :ok
      [current | tail], proc, self_proc ->
        Enum.each(tail, fn next ->
          proc.(current, next)
        end)

        self_proc.(tail, proc, self_proc)
    end
  )
end
