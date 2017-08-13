defmodule Expander.UrlTest do
  use ExUnit.Case, async: true
  doctest Expander.Url, import: true

  alias Expander.{Url}
  import Expander.Url

  test "new without arguments create an empty url" do
    assert %Url{} = new()
  end

  test "new with arguments create a url with fiels populated" do
    url = new(short_url: "http://stpz.co/haddafios")
    assert url.short_url == "http://stpz.co/haddafios"
  end

  test "new raises if arguments contain unknown field" do
    assert_raise ArgumentError, """
    invalid field `:shot` (value="Unknown") for Expander.Url.new/1.
    """, fn -> new(shot: "Unknown") end
  end

  test "short_url/2" do
    url = new() |> short_url("http://stpz.co/haddafios")
    assert url == %Url{short_url: "http://stpz.co/haddafios"}

    url = url |> short_url("http://stpz.co/haddafandroid")
    assert url == %Url{short_url: "http://stpz.co/haddafandroid"}
  end

  test "long_url/2" do
    url = new() |> long_url("https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
    assert url == %Url{long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884"}

    url = url |> long_url("https://play.google.com/store/apps/details?id=com.startappz.haddaf")
    assert url == %Url{long_url: "https://play.google.com/store/apps/details?id=com.startappz.haddaf"}
  end

  test "short_url/2 should raise if url is invalid" do
    assert_raise ArgumentError, """
    expects the url to be a valid url.
    Instead it got:
      `"invalid-url"`.
    """, fn -> new() |> short_url("invalid-url") end
  end

  test "long_url/2 should raise if url is invalid" do
    assert_raise ArgumentError, """
    expects the url to be a valid url.
    Instead it got:
      `"invalid-url"`.
    """, fn -> new(long_url: "invalid-url") end
  end

  test "cache_key/1" do
    url = new() |> short_url("http://stpz.co/haddafios")
    assert cache_key(url) == "http://stpz.co/haddafios"
  end

  test "expanded/1" do
    url = new() |> short_url("http://stpz.co/haddafios")
    assert expanded(url) == false

    url = new() |> long_url("http://stpz.co/haddafios")
    assert expanded(url) == false

    url = new() |> long_url("http://google.com") |> short_url("http://google.com")
    assert expanded(url) == false

    url = new() |> long_url("https://itunes.apple.com/us/app/haddaf-hdaf/id872585884") |> short_url("http://stpz.co/haddafios")
    assert expanded(url) == true
  end

end
