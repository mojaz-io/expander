defmodule Expander.Cache.Adapters.Local.Storage.Memory do

  @moduledoc ~S"""
  In-memory storage driver used by the
  [Expander.Adapters.Local] module.

  The urls are stored in memory and won't persist once your
  application is stopped.
  """

  use GenServer

  @doc """
  Starts the server
  """
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Stops the server
  """
  def stop() do
    GenServer.stop(__MODULE__)
  end


  @doc ~S"""
  List all values in cache.

  ## Examples
      iex> {:ok, conn} = GenServer.start_link(Memory, [])
      iex> Memory.set(conn, "moski", "doski")
      {:ok, "OK"}
      iex> Memory.all(conn)
      %{"moski" => "doski"}
  """
  def all(state) do
    GenServer.call(state, :all)
  end

  @doc ~S"""
  Get a value from cache given the key.

  ## Examples
      iex> {:ok, conn} = GenServer.start_link(Memory, [])
      iex>  Memory.set(conn, "moski", "doski")
      iex> Memory.all(conn) |> Enum.count()
      1
      iex> Memory.get(conn, "moski")
      {:ok, "doski"}
  """
  def get(state,key) do
    GenServer.call(state, {:get, key})
  end

  @doc ~S"""
  Set a key value in cache.

  ## Examples
      iex> {:ok, conn} = GenServer.start_link(Memory, [])
      iex>  Memory.set(conn, "key1", "val1")
      iex>  Memory.set(conn, "key2", "val2")
      iex>  Memory.set(conn, "key3", "val3")
      iex> Memory.all(conn) |> Enum.count()
      3
  """
  def set(state, key, value) do
    GenServer.call(state, {:set, key, value})
  end

  @doc ~S"""
  Delete all keys from cache.

  ## Examples
      iex> {:ok, conn} = GenServer.start_link(Memory, [])
      iex>  Memory.set(conn, "key1", "val1")
      iex>  Memory.set(conn, "key2", "val2")
      iex>  Memory.set(conn, "key3", "val3")
      iex> Memory.all(conn) |> Enum.count()
      3
      iex> Memory.delete_all(conn)
      iex> Memory.all(conn) |> Enum.count()
      0
  """
  def delete_all(state) do
    GenServer.call(state, :delete_all)
  end

  #
  # Callbacks
  #
  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:get, key}, _from, state) do
    {:reply, {:ok, Map.get(state, key)}, state}
  end


  def handle_call({:set, key, value}, _from, state) do
    {:reply, {:ok, "OK"} , Map.put(state, key, value)}
  end

  def handle_call(:all, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:delete_all, _from, _) do
    {:reply, :ok, %{}}
  end

end
