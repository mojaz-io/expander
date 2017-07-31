defmodule Expander.Cache.Adapter.LocalTest do
  use ExUnit.Case, async: true
  defmodule LocalCache do
    use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Local
  end

  setup_all do
    valid_url = Expander.Url.new(
      short_url: "http://stpz.co/haddafios",
      long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884",
    )
    LocalCache.adapter.set(valid_url, [])
    {:ok, valid_url: valid_url}
  end


  test "set/2" do
    url = Expander.Url.new(short_url: "http://amzn.to/2w9oM5d", long_url: "http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create_dashboard.html?sc_channel=sm&sc_campaign=Docs&sc_publisher=TWITTER&sc_country=Global&sc_geo=GLOBAL&sc_outcome=[GLOBAL]&sc_content=Docs&linkId=40350988")
    {:ok, {expanded, config}} = LocalCache.adapter.set(url, [])
    assert {:ok, {expanded, config}} == {:ok, {url, []}}
  end

  test "get/2 returns error if the url not in cache" do
    url = Expander.Url.new(short_url: "http://buff.ly/2eXEo8I")
    assert {:error, :url_not_found} == LocalCache.adapter.get(url, [])
  end

  test "get/2 returns url if in cache", %{valid_url: valid_url} do
    url = Expander.Url.new(short_url: "http://stpz.co/haddafios")
    {:ok, {expanded, config}} = LocalCache.adapter.get(url, [])
    assert {:ok, {expanded, config}} == {:ok, {valid_url, []}}
  end

end
