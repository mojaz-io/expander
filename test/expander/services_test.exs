defmodule ExVCR.Adapter.ServicesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Expander.Hive.Beehive
  alias Expander.Url

  setup_all do
    HTTPoison.start
  end

  @long_url "http://www.skydivedubai.ae/tandem.html#tandem"


  test "Bitly" do
    use_cassette "bitly" do
      short_url = "http://bit.ly/29sQYsu"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "Bitly with custom domain" do
    use_cassette "bitly_custom_domain" do
      short_url = "http://stpz.co/2vvdA5x"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "goo.gl" do
    use_cassette "google" do
      short_url = "https://goo.gl/8SNQv2"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "tinyurl" do
    use_cassette "tinyurl" do
      short_url = "http://tinyurl.com/ycrsmhzj"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "is.gd" do
    use_cassette "isgd" do
      short_url = "https://is.gd/hyZ5Wm"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "ow.ly" do
    use_cassette "owly" do
      short_url = "http://ow.ly/c27U30eng88"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "tiny.cc" do
    use_cassette "tinycc" do
      short_url = "http://tiny.cc/6vi3my"
      assert {:ok, %Url{long_url: @long_url, short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end

  test "tr.im" do
    use_cassette "trim" do
      short_url = "http://tr.im/hacker"
      assert {:ok, %Url{long_url: "https://news.ycombinator.com/?utm_source=tr.im&utm_medium=no_referer&utm_campaign=tr.im%2Fhacker&utm_content=direct_input", short_url: short_url}, %{expanded: true}}   ==  Url.new(short_url: short_url) |>  Beehive.expand
    end
  end
end
