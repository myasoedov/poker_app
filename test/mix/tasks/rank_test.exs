defmodule Mix.Tasks.RankTest do
  use ExUnit.Case, async: true

  setup tags do
    args = tags[:args] || []

    Mix.shell(Mix.Shell.Process)

    if tags[:prompt] do
      Enum.each(tags[:prompt], fn prompt ->
        send self(), {:mix_shell_input, :prompt, prompt}
      end)
    end
    Mix.Tasks.Rank.run(args)

    :ok
  end

  def assert_match(string, word) do
    assert String.match?(string, ~r/#{word}/i)

    string
  end

  @tag args: ["--black=2H 3D 5S 9C KD", "--white=2C 3H 4S 8C AH"]
  test "prints that white wins with ace" do
    assert_received {:mix_shell, :info, [output]}

    output
    |> assert_match("white wins")
    |> assert_match("ace")
  end

  @tag args: ["--black=2H 4S 4C 3D 4H", "--white=2S 8S AS QS 3S"]
  test "prints that white wins with flush" do
    assert_received {:mix_shell, :info, [output]}

    output
    |> assert_match("white wins")
    |> assert_match("flush")
  end

  @tag args: ["--black=2H 3D 5S 9C KD", "--white=2C 3H 4S 8C KH"]
  test "prints that black wins with 9" do
    assert_received {:mix_shell, :info, [output]}

    output
    |> assert_match("black wins")
    |> assert_match("9")
  end

  @tag args: ["--black=2H 3D 5S 9C KD", "--white=2D 3H 5C 9S KH"]
  test "prints about tie" do
    assert_received {:mix_shell, :info, [output]}

    assert_match(output, "tie")
  end

  @tag args: ["--black=unknown"]
  test "prints error when white cards are not set" do
    assert_received {:mix_shell, :error, [error]}
    assert_received {:mix_shell, :info, [usage]}

    assert_match(error, "--white")
    assert_match(usage, "usage")
  end

  @tag args: ["--black=2H 3D 5S 9C KD", "--white=unknown"]
  test "prints error when white cards unrecognized" do
    assert_received {:mix_shell, :error, [error]}
    assert_received {:mix_shell, :info, [usage]}

    assert_match(error, "--white")
    assert_match(usage, "usage")
  end

  @tag args: ["--black=2H 3D9C KD", "--white=2H 3D 5S 9C KD"]
  test "prints error when black cards unrecognized" do
    assert_received {:mix_shell, :error, [error]}
    assert_received {:mix_shell, :info, [usage]}

    assert_match(error, "--black")
    assert_match(usage, "usage")
  end

  @tag args: []
  test "prints error ans usage when arguments is empty" do
    assert_received {:mix_shell, :error, [error]}
    assert_received {:mix_shell, :info, [usage]}

    assert_match(error, "--black")
    assert_match(usage, "usage")
  end

  @tag args: ["--interactive"]
  @tag prompt: ["2H 3D 5S 9C KD", "2C 3H 4S 8C AH"]
  test "runs interactive mode" do
    assert_received {:mix_shell, :prompt, [prompt]}
    assert_match(prompt, "black")

    assert_received {:mix_shell, :prompt, [prompt]}
    assert_match(prompt, "white")

    Mix.Shell.Process.flush(fn
      {:mix_shell, :info, [info]} ->
        if String.match?(info, ~r/white wins/i) &&
           String.match?(info, ~r/ace/i) do
          send self(), :mix_task_result
        end
      {:mix_shell, :error, [error]} -> refute error
      _any -> nil
    end)

    assert_received :mix_task_result
  end
end
