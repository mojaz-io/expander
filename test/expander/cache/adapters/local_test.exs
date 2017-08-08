defmodule Expander.Cache.Adapter.LocalTest do
  use ExUnit.Case, async: true

  alias Expander.Cache.Adapters.Local.Storage.Memory
  alias Expander.Url

  defmodule LocalCache do
    use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Local
  end

  setup_all do
    {:ok, pid} = LocalCache.start_adapter()
    state = :sys.get_state(pid)
    %Expander.Cache.Store{state: conn} =  state

    # Make sure to flush all cache before we start.
    Memory.delete_all(conn)
    {:ok, state: state, conn: conn}
  end

  test "get/2", %{state: state, conn: conn}   do
    assert Expander.Cache.Adapter.Local.get(state, "key") == {:ok, state, :error}

    Memory.set(conn, "key", "value")

    assert Expander.Cache.Adapter.Local.get(state, "key") == {:ok, state, {:ok, "value"}}
  end

  test "set/2", %{state: state, conn: conn}   do
    assert {:ok, state} == Expander.Cache.Adapter.Local.set(state, "key1", "value1")
    assert Memory.get(conn, "key1") == {:ok, "value1"}
  end

  test "expand interface", %{conn: conn} do
    #
    # Manually create url and set in in Memory Directly, then expand should fetch this URL from redis and return it
    #
    url = Url.new(short_url: "http://stpz.co/haddafios", long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
    Memory.set(conn, Url.cache_key(url), Poison.encode!(url))

    assert {:ok, url} == LocalCache.expand(url)
  end
end
