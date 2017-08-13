defmodule Expander.Hive.Bee do
  use GenServer

  alias Expander.Helpers.Http
  alias Expander.Url

  def start_link(opts \\ []) do
    GenServer.start_link __MODULE__, [], opts
  end

  def expand(pid, url=%Url{}) do
    GenServer.call(pid, {url ,:expand})
  end

  def init([]) do
    {:ok, {}}
  end

  def handle_call({url, :expand}, _from, state) do
    expand_state = case Http.expand(url.short_url) do
      {:ok, long_url} -> {:ok, url |> Url.long_url(long_url)}
      {:error, reason} -> {:error, url, %{reason: reason}}
    end

    {:reply, expand_state, state}
  end
end
