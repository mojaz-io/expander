defmodule Expander.Cache.Adapter.MemcacheTest do
  use ExUnit.Case, async: true

  defmodule Cache do
    use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Memcache
  end

  setup_all do
    {:ok, pid} = Cache.start_adapter()
    state = :sys.get_state(pid)
    %Expander.Cache.Store{state: conn} =  state

    # Make sure to flush memcache before we start.
    Memcache.flush(conn)

    {:ok, state: state, conn: conn}
  end

  test "get/2", %{state: state, conn: conn}   do
    assert Expander.Cache.Adapter.Memcache.get(state, "key") == {:ok, state, :error}

    Memcache.set(conn, "key", "value")

    assert Expander.Cache.Adapter.Memcache.get(state, "key") == {:ok, state, {:ok, "value"}}
  end

  test "set/2", %{state: state, conn: conn}   do
    assert {:ok, state} == Expander.Cache.Adapter.Memcache.set(state, "key1", "value1")
    assert Memcache.get(conn, "key1") == {:ok, "value1"}
  end

  test "expand interface", %{conn: conn} do
    #
    # Manually create url and set in in memcache Directly, then expand should fetch this URL from memcache and return it
    #
    url = Expander.Url.new(short_url: "http://stpz.co/haddafios", long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")

    Memcache.set(conn, Expander.Url.cache_key(url), Poison.encode!(url))

    assert {:ok, url} == Cache.expand(url)
  end
end
