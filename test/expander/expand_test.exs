defmodule Expander.ExpandTest do
  use ExUnit.Case, async: true

  alias Expander.ExpandError
  alias Expander.Cache.Store

  Application.put_env(
    :expander,
    Expander.ExpandTest.FakeExpander,
    api_key: "api-key",
    tls: 100
  )

  defmodule FakeAdapter do
    use Expander.Cache.Adapter

    def setup(_), do: {:ok, %{}}
    def get(store = %Store{}, _key), do: {:ok, store, {:ok, "value"}}
    def set(store = %Store{}, _key, _value), do: {:ok, store}
  end

  defmodule FakeExpander do
    use Expander.Expand, otp_app: :expander, adapter: FakeAdapter
  end

  setup_all do
    valid_url = Expander.Url.new(
      short_url: "http://stpz.co/haddafios",
      long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884",
    )
    {:ok, valid_url: valid_url}
  end

  test "should raise if no adapter is specified" do
    assert_raise ArgumentError, fn ->
      defmodule NoAdapterCache do
        use Expander.Expand, otp_app: :expander
      end
    end
  end

  test "should raise if expand!/2 is called with invalid short_url", %{valid_url: valid_url} do
    assert_raise ExpandError, "expand error: expected \"short_url\" to be set", fn ->
      Map.put(valid_url, :short_url, nil) |> FakeExpander.expand!()
    end
  end

  test "config from environment variables", %{valid_url: url} do
    System.put_env("EXPANDER_CACHE_USERNAME", "userenv")
    System.put_env("EXPANDER_CACHE_PASSWORD", "passwordenv")

    Application.put_env(:expander, Expander.ExpandTest.EnvCacheExpander,
      [username: {:system, "EXPANDER_CACHE_USERNAME"},
       password: {:system, "EXPANDER_CACHE_PASSWORD"}])

    defmodule EnvCacheExpander do
      use Expander.Expand, otp_app: :expander, adapter: FakeAdapter
    end

    assert EnvCacheExpander.config() == [
      username: "userenv",
      password: "passwordenv"
    ]
  end
end
