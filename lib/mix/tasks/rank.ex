defmodule Mix.Tasks.Rank do
  use Mix.Task

  alias Poker.GameBase.Card
  alias Poker.GameBase.Rank

  alias Poker.Notation

  @impl Mix.Task
  def run(args) do
    #Mix.shell.info Enum.join(args, " ")

    with {:ok, cards1} <- prompt_cards_for("Black"),
         {:ok, cards2} <- prompt_cards_for("White") do
      compare({"Black", cards1}, {"White", cards2})
    end
  end

  defp prompt_cards_for(user) do
    input = Mix.shell.prompt("Enter cards for #{user}")

    if exit?(input) do
      {:error, :exit}
    else
      case parse(input) do
        {:error, {reason, card}} ->
          Mix.shell.info("Unrecognized card #{card} (#{reason})")
          prompt_cards_for(user)
        {:error, reason} ->
          Mix.shell.info("Can not parse due to #{reason}")
          prompt_cards_for(user)
        {:ok, cards} -> {:ok, cards}
      end
    end
  end

  defp parse(input) do
    with {:ok, cards} <- Notation.parse(input) do
      if Enum.count(cards) == 5 do
        {:ok, cards}
      else
        {:error, :wrong_cards_number}
      end
    end
  end

  defp compare({name1, cards1}, {name2, cards2}) do
    case Poker.GameBase.Rank.compare(cards1, cards2) do
      :eq -> Mix.shell.info("Tie")
      {:gt, {:rule, rule}} -> Mix.shell.info("#{name1} wins - #{rule}")
      {:gt, {:card, card}} -> Mix.shell.info("#{name1} wins - highest card - #{Card.value(card)}")
      {:lt, {:rule, rule}} -> Mix.shell.info("#{name2} wins - #{rule}")
      {:lt, {:card, card}} -> Mix.shell.info("#{name2} wins - highest card - #{Card.value(card)}")
    end
  end

  defp exit?(input) do
    input |> String.trim() == "\q"
  end
end
