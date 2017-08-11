defmodule Expander.Cache.ServerTest do
  use ExUnit.Case, async: true

  alias Expander.Cache.Server

  setup do
    {:ok, pid} = Server.start_link(Expander.Cache.Adapter.Local, [], [name: Expander.Cache.Server])
    store = :sys.get_state(pid)

    valid_url = Expander.Url.new(
      short_url: "http://stpz.co/haddafios",
      long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884",
    )

    {:ok, store: store, pid: pid, valid_url: valid_url}
  end

  test ".in_cache return {:ok, false} when value not in cache", %{pid: pid, valid_url: url} do
    assert GenServer.call(pid, {:in_cache, url}) == {:ok, false}
  end

  test ".in_cache return {:ok, true, url} when value in cache", %{pid: pid, valid_url: url} do
    GenServer.call(pid, {:set, url})
    assert GenServer.call(pid, {:in_cache, url}) == {:ok, true, url}
  end

  test ".get return nil when value not in cache", %{pid: pid, valid_url: url} do
    assert GenServer.call(pid, {:get, url}) == nil
  end

  test ".get return url when value in cache", %{pid: pid, valid_url: url} do
    GenServer.call(pid, {:set, url})
    assert GenServer.call(pid, {:get, url}) == {:ok, url}
  end

  test ".set sets the url in cache", %{pid: pid, valid_url: url} do
    assert GenServer.call(pid, {:set, url}) == :ok
  end
end
