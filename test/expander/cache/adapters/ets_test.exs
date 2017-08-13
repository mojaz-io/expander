defmodule Expander.Cache.Adapter.ETSTest do
  use ExUnit.Case, async: true
  alias Expander.Url

  Application.put_env(
    :expander,
    Expander.Cache.Adapter.ETSTest.ETSCache,
    privacy: :public
  )
  defmodule ETSCache do
    use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.ETS
  end

  setup_all do
    {:ok, pid} = ETSCache.start_adapter()
    state = :sys.get_state(pid)
    %Expander.Cache.Store{state: table} =  state

    # Make sure to flush redis before we start.
    #Redix.command!(conn, ["FLUSHDB"])
    {:ok, state: state, table: table}
  end

  test "get/2", %{state: state, table: table}   do
    assert Expander.Cache.Adapter.ETS.get(state, "key") == {:ok, state, :error}
    :ets.insert(table, {"key", "value"})
    assert Expander.Cache.Adapter.ETS.get(state, "key") == {:ok, state, {:ok, "value"}}
  end

   test "set/2", %{state: state}   do
    assert {:ok, state} == Expander.Cache.Adapter.ETS.set(state, "key1", "value1")
    assert Expander.Cache.Adapter.ETS.get(state, "key1") == {:ok, state, {:ok, "value1"}}
  end

  test "expand interface", %{table: table} do
    #
    # Manually create url and set in in ets Directly, then expand should fetch this URL from redis and return it
    #
    url = Url.new(short_url: "http://stpz.co/haddafios", long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
    :ets.insert(table, {Url.cache_key(url),  Poison.encode!(url)})
    assert {:ok, url, %{expanded: true, source: :cache}} == ETSCache.expand(url)
  end
end
