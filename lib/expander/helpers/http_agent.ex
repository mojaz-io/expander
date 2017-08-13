defmodule Expander.Helpers.HttpAgent do

  @moduledoc ~S"""
    A utility to return the a different Agent based on the base domain.
    Some services such as FB will block requests coming from HTTPotion and redirect it to unsupported browser page

    ## Example

      iex> Expander.Helpers.HttpAgent.agent("http://fb.me/2aTIpGhTr")
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"

      iex> Expander.Helpers.HttpAgent.agent("http://tiny.cc/c9t1my")
      "expander v0.0.1"
  """
  @safari "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.7.12 (KHTML, like Gecko) Version/8.0.7 Safari/600.7.12"
  @expander "expander v#{Expander.version}"

  #
  def agent(url), do: do_agent(URI.parse(url))

  #
  defp do_agent(%URI{host: "fb.me"}), do: safari_agent()
  defp do_agent(_), do: expander_agent()

  @doc false
  def safari_agent, do: @safari
  def expander_agent, do: @expander
end
