defmodule Expander.Hive.BeehiveTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney, clear_mock: true

  alias Expander.Url
  alias Expander.Hive.Beehive

  setup_all do
    HTTPoison.start
  end

  test "expand/1 list" do
    use_cassette "beehive_expand_list" do
      urls = [
        Url.new(short_url: "http://bit.ly/29sQYsu"),
        Url.new(short_url: "http://tr.im/hacker")
      ]
      assert [{:ok, %Expander.Url{long_url: "http://www.skydivedubai.ae/tandem.html#tandem", short_url: "http://bit.ly/29sQYsu"}, %{expanded: true}},
              {:ok, %Expander.Url{long_url: "https://news.ycombinator.com/?utm_source=tr.im&utm_medium=no_referer&utm_campaign=tr.im%2Fhacker&utm_content=direct_input", short_url: "http://tr.im/hacker"}, %{expanded: true}}]
              ==  urls |>  Beehive.expand
    end
  end

  test "expand/1 url" do
    use_cassette "beehive_expand_url" do
        assert {:ok, %Expander.Url{long_url: "http://www.skydivedubai.ae/tandem.html#tandem", short_url: "http://bit.ly/29sQYsu"}, %{expanded: true}}
               == Url.new(short_url: "http://bit.ly/29sQYsu") |> Beehive.expand
    end
  end

  test "expand/1 url not expanded" do
    use_cassette "beehive_expand_url_not_expanded" do
        url = "https://news.ycombinator.com"
        assert {:ok, %Expander.Url{long_url: url, short_url: url}, %{expanded: false}}
               == Url.new(short_url: url) |> Beehive.expand
    end
  end

  @tag :wip
  test "expand/1 invalid url" do
    use_cassette "beehive_expand_invalid_url" do
        url = "http://tiny.cc/moski"
        assert {:error, %Expander.Url{long_url: nil, short_url: url}, %{expanded: false, reason: "#{url} returned with states_code: 404"}}
               == Url.new(short_url: url) |> Beehive.expand
    end
  end

  @tag :wip
  test "expand/1 invalid domain" do
    use_cassette "beehive_expand_invalid_domain" do
      url = "http://invalid.domain"
      assert {:error, %Expander.Url{long_url: nil, short_url: url}, %{expanded: false, reason: "#{url} returned with error: nxdomain"}}
            == Url.new(short_url: url) |> Beehive.expand

    end
  end
end
