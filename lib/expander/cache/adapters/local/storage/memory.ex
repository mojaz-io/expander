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
  Push a new url into the list.

  The key used to fetch the url is the short_url

  ## Examples
      iex> url = Expander.Url.new() |> Expander.Url.short_url("http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
      iex> Memory.set(url)
      iex> Memory.all()
      %{"http://stpz.co/haddafios" => %Expander.Url{long_url: nil, short_url: "http://stpz.co/haddafios"}}
  """
  def set(url) do
    GenServer.call(__MODULE__, {:set, url})
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
  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
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
  def all() do
    GenServer.call(__MODULE__, :all)
  end

  @doc ~S"""
  Delete all stored urls.

  ## Examples
      iex> url = Expander.Url.new(short_url: "http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
      iex> Memory.set(url)
      %Expander.Url{short_url: "http://stpz.co/haddafios"}
      iex> Memory.delete_all()
      :ok
      iex> Memory.all() |> Enum.count()
      0
  """
  def delete_all() do
    GenServer.call(__MODULE__, :delete_all)
  end


  # Callbacks

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(:all, _from, urls) do
    {:reply, urls, urls}
  end

  def handle_call(:delete_all, _from, _urls) do
    {:reply, :ok, %{}}
  end

  def handle_call({:set, url}, _from, urls) do
    # Check if the URL is already in the set, if so update it, otherwise add it.
    {_, urls} =  Map.get_and_update(urls, url.short_url, fn current_value ->
      {current_value, url}
    end)

    {:reply, url, urls}
  end

  def handle_call({:get, id}, _from, urls) do
    url = Map.get(urls, id)
    {:reply, url, urls}
  end
end
