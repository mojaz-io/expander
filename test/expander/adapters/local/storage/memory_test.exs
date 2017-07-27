defmodule Expander.Adapters.Local.Storage.MemoryTest do
  use ExUnit.Case

  alias Expander.Adapters.Local.Storage.Memory

  doctest Expander.Adapters.Local.Storage.Memory, import: true

  setup do
    Memory.delete_all()
    :ok
  end

  test "start_link/0 starts with an empty mailbox" do
    {:ok, pid} = GenServer.start_link(Memory, [])
    count = GenServer.call(pid, :all) |> Enum.count
    assert count == 0
  end

  test "set a url into the list" do
    Memory.set(%Expander.Url{short_url: "http://stpz.co/haddafios"})
    assert Memory.all() |> Enum.count() == 1
  end

  test "set a duplicate url into the list" do
    Memory.set(%Expander.Url{short_url: "http://stpz.co/haddafios"})
    Memory.set(%Expander.Url{short_url: "http://stpz.co/haddafios"})
    assert Memory.all() |> Enum.count() == 1
  end


  test "get a url from the list" do
    Memory.set(%Expander.Url{short_url: "http://example1.com"})
    Memory.set(%Expander.Url{short_url: "http://example2.com"})
    Memory.set(%Expander.Url{short_url: "http://example3.com"})
    assert %Expander.Url{short_url: "http://example2.com"} = Memory.get("http://example2.com")
  end

  test "delete all the urls" do
    Memory.set(%Expander.Url{short_url: "http://example1.com"})
    Memory.set(%Expander.Url{short_url: "http://example2.com"})
    assert Memory.all() |> Enum.count() == 2

    Memory.delete_all()
    assert Memory.all() |> Enum.count() == 0
  end
end
