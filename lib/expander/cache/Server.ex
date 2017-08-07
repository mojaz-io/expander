defmodule Expander.Cache.Server do
  use GenServer

  alias Expander.Url

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link(adapter, store, server) do
    GenServer.start_link(__MODULE__, {adapter, store}, server)
  end

  def init({adapter, config}) do
    with {:ok, state} <- adapter.setup(config),
         store        <- Expander.Cache.Store.new(adapter, config, state),
    do: {:ok, store}
  end


  def handle_call({:in_cache, %Expander.Url{} = url}, _, store = %Expander.Cache.Store{adapter: adapter}) do
    case adapter.get(store, Url.cache_key(url)) do
      {:ok, store, :error} -> {:reply, {:ok, false}, store}
      {:ok, store, {:ok, value}}  -> {:reply, {:ok, true, Poison.decode!(value, as: %Expander.Url{})}, store}
      {:raise, type, args} -> {:reply, {:raise, type, deserialize_error(args, store)}, store}
    end
  end

  def handle_call({:get, %Expander.Url{} = url}, _, store = %Expander.Cache.Store{adapter: adapter}) do
    case adapter.get(store, Url.cache_key(url)) do
      {:ok, store, :error} -> {:reply, nil, store}
      {:ok, store, {:ok, value}}  -> {:reply, {:ok, Poison.decode!(value, as: %Expander.Url{})}, store}
      {:raise, type, args} -> {:reply, {:raise, type, deserialize_error(args, store)}, store}
    end
  end

  def handle_call({:set, %Expander.Url{} = url}, _, store = %Expander.Cache.Store{adapter: adapter}) do
    value = Poison.encode!(url)
    case adapter.set(store, Url.cache_key(url), value) do
      {:ok, store}         -> {:reply, :ok, store}
      {:raise, type, args} -> {:reply, {:raise, type, deserialize_error(args, store)}, store}
    end
  end

  ##
  ## @TODO
  ##
  defp deserialize_error(opts, _store) do
    case Keyword.fetch(opts, :key) do
      :error -> opts
      {:ok, _key} -> opts
    end
  end
end
