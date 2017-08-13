defmodule Expander.Helpers.HttpAgentTest do
  use ExUnit.Case, async: true

  test "it return the correct agent for FB shortening service" do
    assert Expander.Helpers.HttpAgent.agent("http://fb.me/2aTIpGhTr") == Expander.Helpers.HttpAgent.safari_agent
  end

  test "it return the correct agent for regular cases" do
    assert Expander.Helpers.HttpAgent.agent("http://tr.im/hacker") == Expander.Helpers.HttpAgent.expander_agent
  end
end
