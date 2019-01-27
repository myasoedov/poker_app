defmodule Iteration do
  def run([_current | []], _proc), do: :ok
  def run([current | tail], proc) do
    proc.(current, tail)

    Iteration.run(tail, proc)
  end
end
