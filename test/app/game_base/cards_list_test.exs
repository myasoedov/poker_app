defmodule Poker.GameBase.CardsListTest do
  use ExUnit.Case

  alias Poker.GameBase.CardsList
  alias Poker.GameBase.Card

  defdelegate parse(line), to: Poker.Notation.Short

  describe "compare" do
    test "returns correct comparison" do
      {:ok, list1} = parse("2S 4H JD")
      {:ok, list2} = parse("KC 3H 5D")

      assert {:lt, {:king, :clubs}} = CardsList.compare(list1, list2)
      assert {:gt, {:king, :clubs}} = CardsList.compare(list2, list1)
      assert :eq = CardsList.compare(list1, list1)
      assert :eq = CardsList.compare(list2, list2)
    end

    test "returns eq" do
      {:ok, list1} = parse("2S 4H JD")
      {:ok, list2} = parse("JC 4H 2D")

      assert :eq = CardsList.compare(list1, list2)
    end
  end

  describe "highest_card" do
    test "returns correct highest card" do
      {:ok, list1} = parse("2S 4H JD")

      assert {:jack, :diamonds} = CardsList.highest_card(list1)
    end
  end

  describe "take group_of" do
    test "returns correct group" do
      {:ok, list1} = parse("4H JD 6H 6S AH")

      assert {group, left} = CardsList.take_group_of(list1, 2, &Card.value/1)
      assert Enum.count(group) == 2
      assert Enum.count(left) == 3
      assert {6, :hearts} in group
      assert {6, :spades} in group
      assert {4, :hearts} in left
      assert {:jack, :diamonds} in left
      assert {:ace, :hearts} in left

      assert {group, left} = CardsList.take_group_of(list1, 3, &Card.suit/1)
      assert Enum.count(group) == 3
      assert Enum.count(left) == 2
      assert {6, :hearts} in group
      assert {4, :hearts} in group
      assert {:ace, :hearts} in group
      assert {6, :spades} in left
      assert {:jack, :diamonds} in left
    end

    test "returns nil if no suitable group" do
      {:ok, list1} = parse("4H JD 6H 6S AH")

      assert nil == CardsList.take_group_of(list1, 3, &Card.value/1)
    end

    test "returns nil if group is bigger" do
      {:ok, list1} = parse("4H JD 6H 6S AH")

      assert nil == CardsList.take_group_of(list1, 2, &Card.suit/1)
    end
  end

  describe "take highest_pair" do
    test "returns highest pair" do
      {:ok, list1} = parse("TS TH JS JD AD")

      assert {pair, left} = CardsList.take_highest_pair(list1)
      assert Enum.count(pair) == 2
      assert Enum.count(left) == 3
      assert {:jack, :spades} in pair
      assert {:jack, :diamonds} in pair
      assert {10, :spades} in left
      assert {10, :hearts} in left
      assert {:ace, :diamonds} in left

      assert {pair, left} = CardsList.take_highest_pair(left)
      assert Enum.count(pair) == 2
      assert Enum.count(left) == 1

      assert {10, :spades} in pair
      assert {10, :hearts} in pair
      assert {:ace, :diamonds} in left
    end

    test "returns nil if no pairs" do
      {:ok, list1} = parse("TS 2H JS 4D AD")

      assert nil == CardsList.take_highest_pair(list1)
    end
  end

  describe "count_groups_of" do
    test "returns correct count of groups" do
      {:ok, list1} = parse("4H JD 6H 6S 4H")

      assert 2 == CardsList.count_groups_of(list1, 2, &Card.value/1)
      assert 0 == CardsList.count_groups_of(list1, 3, &Card.value/1)

      assert 1 = CardsList.count_groups_of(list1, 3, &Card.suit/1)
    end
  end

  describe "consecutive?" do
    test "returns true if consecutive" do
      {:ok, list1} = parse("JS QH TC 8C 9D")

      assert CardsList.consecutive?(list1)
    end

    test "returns false" do
      {:ok, list1} = parse("JS QH 9C 8C 9D")

      refute CardsList.consecutive?(list1)
    end
  end

  describe "all_same_suit?" do
    test "returns true" do
      {:ok, list1} = parse("JH QH 9H 8H 9H")

      assert CardsList.all_same_suit?(list1)
    end

    test "returns false" do
      {:ok, list1} = parse("JH QH 9S 8H 9H")

      refute CardsList.all_same_suit?(list1)
    end
  end
end
