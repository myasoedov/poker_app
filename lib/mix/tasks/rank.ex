defmodule Mix.Tasks.Rank do
  @moduledoc false

  use Mix.Task

  alias Poker.GameBase.Card
  alias Poker.GameBase.Rank
  alias Poker.GameBase.Rule
  alias Poker.Notation

  @impl Mix.Task
  def run(args) do
    if Enum.any?(args, & &1 == "--interactive") do
      interactive()
    else
      command_line(args)
    end
  end

  defp command_line(args) do
    cards1 = get_argument(args, "--black")
    cards2 = get_argument(args, "--white")

    with {:black, cards1} when not is_nil(cards1) <- {:black, cards1},
         {:white, cards2} when not is_nil(cards2) <- {:white, cards2},
         {:black, {:ok, cards1}} <- {:black, parse(cards1)},
         {:white, {:ok, cards2}} <- {:white, parse(cards2)} do
      compare({"Black", cards1}, {"White", cards2})
    else
      {user, nil} ->
        Mix.shell.info("Argument --#{user} is not set")
        show_usage()

      {user, {:error, reason}} ->
        Mix.shell.info("Parse --#{user} failed : #{parse_error(reason)}")
        show_usage()
    end
  end

  defp interactive do
    Mix.shell.info("Who wins?")
    Mix.shell.info("* enter \\q to exit")

    with {:ok, cards1} <- prompt_cards_for("Black"),
         {:ok, cards2} <- prompt_cards_for("White") do
      compare({"Black", cards1}, {"White", cards2})
    end
  end

  defp prompt_cards_for(user) do
    input = Mix.shell.prompt("Enter cards for #{user}:")

    if exit?(input) do
      {:error, :exit}
    else
      case parse(input) do
        {:ok, cards} -> {:ok, cards}
        {:error, reason} ->
          Mix.shell.info(parse_error(reason))
          prompt_cards_for(user)
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

  defp parse_error({reason, card}), do: "Unrecognized card #{card} (#{reason})"
  defp parse_error(:wrong_cards_number), do: "Wrong cards number"
  defp parse_error(reason), do: "Failed due to #{reason}"

  defp compare({name1, cards1}, {name2, cards2}) do
    case Rank.compare(cards1, cards2) do
      :eq -> Mix.shell.info("Tie")
      {:gt, reason} -> Mix.shell.info("#{name1} wins - #{win_reason(reason)}")
      {:lt, reason} -> Mix.shell.info("#{name2} wins - #{win_reason(reason)}")
    end
  end

  defp win_reason({:card, card}), do: "highest card #{Card.value(card)}"
  defp win_reason({:rule, rule}), do: Rule.to_string(rule)

  defp exit?(input) do
    input |> String.trim() == "\\q"
  end

  defp get_argument(args, key) do
    regexp = ~r/\A#{key}\s*=(.*)\z/

    Enum.find_value(args, fn arg ->
      if String.match?(arg, regexp) do
        case Regex.scan(regexp, arg) do
          [[_all, value]] -> value
          _any -> nil
        end
      end
    end)
  end

  defp show_usage do
    Mix.shell.info("Usage: mix rank --white=\"2H 3D 5S 9C KD\" --black=\"2C 3H 4S 8C AH\"")
    Mix.shell.info("Arguments:")
    Mix.shell.info("  --interactive   Interactive mode")
    Mix.shell.info("  --white         Cards list for white")
    Mix.shell.info("  --black         Cards list for black")
  end
end
