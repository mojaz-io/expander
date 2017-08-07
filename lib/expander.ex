defmodule Expander do
  @moduledoc """
  Documentation for Expander.
  """

  @version "0.0.1"

  @typedoc """
  Keys allowed in Store entries.
  """
  @type key :: term

  @typedoc """
  Values allowed in Store entries.
  """
  @type value :: term

  @typedoc """
  An instruction to the `Expander.Cache.Server ` to raise an error in the client.
  """
  @type exception :: {:raise, Module.t, raise_opts :: Keyword.t}


  @doc false
  def version, do: @version
end
