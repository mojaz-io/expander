defmodule Expander.Cache.Adapter.Local do
  use Expander.Cache.Adapter
  alias Expander.Cache.Store

  def setup(_) do
    Expander.Cache.Adapters.Local.Storage.Memory.start_link()
  end

  @spec get(Expander.Cache.Store.t, Expander.key)
    :: {:ok, Expander.Cache.Store.t, {:ok, Expander.value} | :error} | Expander.exception
  def get(store = %Store{state: conn}, key) do
    case  Redix.command(conn, ["GET", key]) do
      {:ok, nil}       -> {:ok, store, :error}
      {:ok, value}     -> {:ok, store, {:ok, value}}
      {:error, reason} -> {:raise, Exception, [reason: reason]}
    end
  end
end
