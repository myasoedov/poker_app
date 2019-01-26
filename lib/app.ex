defmodule Poker do
  @moduledoc """
  Poker keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmacro dep(class) do
    if Mix.env() == :test do
      quote do overridable_dependency(unquote(class)) end
    else
      quote do unquote(class) end
    end
  end

  defmacro overridable_dependency(class) do
    caller = __CALLER__.module

    quote do
      with {:ok, env} <- Application.fetch_env(:poker, unquote(caller)),
           {:ok, deps} <- Keyword.fetch(env, :deps),
           {:ok, dep} <- Keyword.fetch(deps, unquote(class)) do
        dep
      else
        _any -> unquote(class)
      end
    end
  end
end
