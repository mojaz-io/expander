defmodule Expander.Cache.Adapters.Local.Storage.MemoryTest do
  use ExUnit.Case

  alias Expander.Cache.Adapters.Local.Storage.Memory

  #doctest Expander.Cache.Adapters.Local.Storage.Memory, import: true

  setup context do
    if context[:no_setup] do
      {:ok, %{}}
    else
      {:ok, conn} = GenServer.start_link(Memory, [])
      {:ok, %{conn: conn}}
    end
  end

  @tag :no_setup
  test "start_link/0 starts with an empty mailbox" do
    {:ok, pid} = GenServer.start_link(Memory, [])
    count = GenServer.call(pid, :all) |> Enum.count
    assert count == 0
  end

  test "set/2", %{conn: conn} do
    result = Memory.set(conn, "key", "value")
    assert {:ok, "OK"} == result
    assert Memory.all(conn) |> Enum.count() == 1
  end

  test "set a duplicate url into the list", %{conn: conn} do
    Memory.set(conn, "key", "value")
    Memory.set(conn, "key", "value")
    assert Memory.all(conn) |> Enum.count() == 1
  end

  test "get/2", %{conn: conn} do
    Memory.set(conn, "key1", "value1")
    Memory.set(conn, "key2", "value2")
    Memory.set(conn, "key3", "value3")
    assert Memory.get(conn, "key2") == {:ok, "value2"}
  end

  test "delete all the urls", %{conn: conn} do
    Memory.set(conn, "key1", "value1")
    Memory.set(conn, "key2", "value2")
    assert Memory.all(conn) |> Enum.count() == 2

    Memory.delete_all(conn)
    assert Memory.all(conn) |> Enum.count() == 0
  end
end
