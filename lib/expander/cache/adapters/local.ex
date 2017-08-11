defmodule Expander.Cache.Adapter.Local do

  @moduledoc ~S"""
  An adapter that uses Memory as a caching engine.

  ## Example

      # config/config.exs
      config :sample, Sample.Expander,
        adapter: Expander.Cache.Adapter.Local

      # lib/sample/expander.ex
      defmodule Sample.Expander do
        use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Redix
      end
  """


  use Expander.Cache.Adapter
  alias Expander.Cache.Store
  alias Expander.Cache.Adapters.Local.Storage.Memory

  @doc """
    Connects to Memory Map to store data using provided `config`.
  """
  def setup(_) do
    Expander.Cache.Adapters.Local.Storage.Memory.start_link()
  end

  @spec get(Expander.Cache.Store.t, Expander.key)
    :: {:ok, Expander.Cache.Store.t, {:ok, Expander.value} | :error} | Expander.exception
  def get(store = %Store{state: conn}, key) do
    case  Memory.get(conn, key) do
      {:ok, nil}       -> {:ok, store, :error}
      {:ok, value}     -> {:ok, store, {:ok, value}}
    end
  end

  @spec set(Expander.Cache.Store.t, Expander.key, Expander.value)
    :: {:ok, Expander.Cache.Store.t} | Expander.exception
  def set(store = %Store{state: conn}, key, value) do
    case  Memory.set(conn, key, value) do
      {:ok, "OK"}      -> {:ok, store}
    end
  end
end
