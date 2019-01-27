defmodule Poker.Overridable do
  @moduledoc false

  defmacro overridable(class) do
    if Mix.env() == :test do
      quote do Poker.Overridable.get(unquote(class)) end
    else
      quote do unquote(class) end
    end
  end

  def get(class), do: Keyword.get(config(), class, class)

  def replace(class, override) do
    Application.put_env(
      :poker,
      __MODULE__,
      Keyword.put(config(), class, override)
    )
  end

  def reset, do: Application.put_env(:poker, __MODULE__, [])

  defp config, do: Application.get_env(:poker, __MODULE__, [])
end
