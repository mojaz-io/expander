defmodule Expander.Cache.Supervisor do

  use Supervisor

  def add_adapter(adapter, store, server) do
    spec = worker(Expander.Cache.Server, [adapter, store, server], [id: server, restart: :transient])
    Supervisor.start_child(__MODULE__, spec)
  end

  def find_adapter(name) do
    Enum.find adapters(), fn(adapter) ->
      adapter == [name: name]
    end
  end

  def adapters do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({name, _ , _, _}) -> name end)
  end

  ###
  # Supervisor API
  ###

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end
end
