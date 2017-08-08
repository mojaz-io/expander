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
  List all stored urls.

  ## Examples
      iex> url = Expander.Url.new() |> Expander.Url.short_url("http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
      iex> Memory.set(url)
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
      iex> Memory.all()
      %{"http://stpz.co/haddafios" => %Expander.Url{long_url: nil, short_url: "http://stpz.co/haddafios"}}
  """
  def all(state) do
    GenServer.call(state, :all)
  end

  @doc ~S"""
  Get the url record given the short_url as an ID

  ## Examples
      iex> url = Expander.Url.new() |> Expander.Url.short_url("http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
      iex> Memory.set(url)
      iex> Memory.all() |> Enum.count()
      1
      iex> Memory.get("http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
  """
  def get(state,key) do
    GenServer.call(state, {:get, key})
  end


  def set(state, key, value) do
    GenServer.call(state, {:set, key, value})
  end

  def delete_all(state) do
    GenServer.call(state, :delete_all)
  end

  # Callbacks
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

  def handle_call(:delete_all, _from, state) do
    {:reply, :ok, %{}}
  end

  # @doc ~S"""
  # Push a new url into the list.

  # The key used to fetch the url is the short_url

  # ## Examples
  #     iex> url = Expander.Url.new() |> Expander.Url.short_url("http://stpz.co/haddafios")
  #     %Expander.Url{short_url: "http://stpz.co/haddafios"}
  #     iex> Memory.set(url)
  #     iex> Memory.all()
  #     %{"http://stpz.co/haddafios" => %Expander.Url{long_url: nil, short_url: "http://stpz.co/haddafios"}}
  # """




  # @doc ~S"""
  # List all stored urls.

  # ## Examples
  #     iex> url = Expander.Url.new() |> Expander.Url.short_url("http://stpz.co/haddafios")
  #     %Expander.Url{short_url: "http://stpz.co/haddafios"}
  #     iex> Memory.set(url)
  #     %Expander.Url{short_url: "http://stpz.co/haddafios"}
  #     iex> Memory.all()
  #     %{"http://stpz.co/haddafios" => %Expander.Url{long_url: nil, short_url: "http://stpz.co/haddafios"}}
  # """
  # def all() do
  #   GenServer.call(__MODULE__, :all)
  # end

  # @doc ~S"""
  # Delete all stored urls.

  # ## Examples
  #     iex> url = Expander.Url.new(short_url: "http://stpz.co/haddafios")
  #     %Expander.Url{short_url: "http://stpz.co/haddafios"}
  #     iex> Memory.set(url)
  #     %Expander.Url{short_url: "http://stpz.co/haddafios"}
  #     iex> Memory.delete_all()
  #     :ok
  #     iex> Memory.all() |> Enum.count()
  #     0
  # """



  # # Callbacks









  # def handle_call({:get, id}, _from, urls) do
  #   url = Map.get(urls, id)
  #   {:reply, url, urls}
  # end
end
