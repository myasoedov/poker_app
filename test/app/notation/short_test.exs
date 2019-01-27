defmodule Poker.Notation.ShortTest do
  use ExUnit.Case

  alias Poker.Notation.Short

  test "returns list of card" do
    assert {:ok, list} = Short.parse(" 2C 3D 4H 5S 6c 7d 8h 9s tc JD QH KS Ac")
    assert {2, :clubs} in list
    assert {3, :diamonds} in list
    assert {4, :hearts} in list
    assert {5, :spades} in list
    assert {6, :clubs} in list
    assert {7, :diamonds} in list
    assert {8, :hearts} in list
    assert {9, :spades} in list
    assert {10, :clubs} in list
    assert {:jack, :diamonds} in list
    assert {:queen, :hearts} in list
    assert {:king, :spades} in list
    assert {:ace, :clubs} in list
  end

  test "returns list with one card" do
    assert {:ok, [{10, :diamonds}]} = Short.parse(" Td ")
  end

  test "returns error wrong_length" do
    assert {:error, {:wrong_length, "ABC"}} = Short.parse(" 2C ABC 3D 4H ")
  end

  test "returns error wrong_value" do
    assert {:error, {:wrong_value, "1D"}} = Short.parse("1d")
  end

  test "returns error wrong_suit" do
    assert {:error, {:wrong_suit, "5U"}} = Short.parse("5u")
  end
end
