defmodule Poker.Notation.Short do
  alias Poker.Notation.Behaviour
  alias Poker.GameBase.Card

  @behaviour Behaviour

  @value_sym ~W(2 3 4 5 6 7 8 9 T J Q K A)
  @suit_sym ~W(C D H S)

  def parse(line) do
    line
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&prepare/1)
    |> Enum.map(&parse_entity/1)
    |> Enum.reduce({:ok, []}, fn
      {:ok, note}, {:ok, list} -> {:ok, [note | list]}
      _any, {:error, reason} -> {:error, reason}
      {:error, reason}, _any -> {:error, reason}
    end)
  end

  defp parse_entity(note) do
    cond do
      String.length(note) != 2 -> {:error, {:wrong_length, note}}
      String.at(note, 0) not in @value_sym -> {:error, {:wrong_value, note}}
      String.at(note, 1) not in @suit_sym -> {:error, {:wrong_suit, note}}
      true ->
        value = note |> String.at(0) |> detect_value()
        suit = note |> String.at(1) |> detect_suit()

        {:ok, Card.create(value, suit)}
    end
  end

  defp detect_value(sym) do
    case Integer.parse(sym) do
      {value, ""} -> value
      _result ->
        case sym do
          "T" -> 10
          "J" -> :jack
          "Q" -> :queen
          "K" -> :king
          "A" -> :ace
        end
    end
  end

  defp detect_suit("C"), do: :clubs
  defp detect_suit("D"), do: :diamonds
  defp detect_suit("H"), do: :hearts
  defp detect_suit("S"), do: :spades

  defp prepare(string), do: string |> String.trim() |> String.upcase()
end
