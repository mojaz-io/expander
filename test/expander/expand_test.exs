defmodule Expander.ExpandTest do
  use ExUnit.Case, async: true

  alias Expander.ExpandError

  Application.put_env(
    :expander,
    Expander.ExpandTest.FakeExpander,
    api_key: "api-key",
    tls: 100
  )

  defmodule FakeAdapter do
    use Expander.Cache.Adapter

    def get(url, config), do: {:ok, {url, config}}
    def set(url, config), do: {:ok, {url, config}}

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

  test "dynamic adapter", %{valid_url: url} do
    defmodule OtherAdapterCache do
      use Expander.Expand, otp_app: :expander, adapter: NotExistAdapter
    end

    assert {:ok, _} = OtherAdapterCache.expand(url, adapter: FakeAdapter)
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

    assert EnvCacheExpander.expand(url) ==
      {:ok, {url, [
        username: "userenv",
        password: "passwordenv"
      ]}}
  end

  test "merge config passed to expand/2 into Expander's config", %{valid_url: url} do
    assert FakeExpander.expand(url, tls: 200) ==
      {:ok, {url, [api_key: "api-key", tls: 200]}}
  end

  test "validate config passed to expand/2", %{valid_url: url} do
    defmodule NoConfigAdapter do
      use Expander.Cache.Adapter, required_config: [:api_key]
      def get(_url, _config), do: {:ok, nil}
      def set(_url, _config), do: {:ok, nil}
    end

    defmodule NoConfigMailer do
      use Expander.Expand, otp_app: :expander, adapter: NoConfigAdapter
    end

    assert_raise ArgumentError, """
    expected [:api_key] to be set, got: [domain: "jarvis.com"]
    """, fn ->
      NoConfigMailer.expand(url, domain: "jarvis.com")
    end
  end

end
