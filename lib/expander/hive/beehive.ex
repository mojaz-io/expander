defmodule Expander.Hive.Beehive do
  use Supervisor

  @poolboy :hive_poolboy
  @transaction_timeout_ms 1_000_000 # larger just to be safe
  @timeout_ms 1_000_000


  alias Expander.Hive.Bee
  alias Expander.Url

  def start_link do
   Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    hive_opts = [
      name: {:local, @poolboy},
      worker_module: Bee,
      size: 20,
      max_overflow: 20
    ]

    children = [
      :poolboy.child_spec(@poolboy, hive_opts)
    ]

    supervise(children, strategy: :one_for_one, name: __MODULE__)
  end

  def expand(urls) when is_list(urls) do
    urls
      |> Enum.map(&bee_task/1)
      |> Enum.map(&Task.await(&1, @timeout_ms))
      |> Enum.map(&filter_url/1)
  end

  def expand(url) do
    [head|_] = expand([url])
    head
  end

  defp bee_task(url) do
    Task.async fn ->
      :poolboy.transaction @poolboy, fn(pid) -> Bee.expand(pid, url) end, @transaction_timeout_ms
    end
  end

  defp filter_url({:ok, url = %Url{}}), do: {:ok, url, %{expanded: Url.expanded(url)}}
  defp filter_url({:error, url = %Url{}, %{reason: reason}}), do: {:error, url, %{expanded: Url.expanded(url), reason: reason}}
end
