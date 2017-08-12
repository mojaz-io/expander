defmodule Expander.Cache.Adapter.ETS do
  @moduledoc ~S"""
    An adapter that uses ETS as a caching engine.

    ## Example

        # config/config.exs
        config :sample, Sample.Expander,
          adapter: Expander.Cache.Adapter.ETS

        # lib/sample/expander.ex
        defmodule Sample.Expander do
          use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.ETS
        end
  """

  use Expander.Cache.Adapter
  alias Expander.Cache.Store

  @doc """
  Creates a new ETS table to store state using provided `opts`.

  ## Options

  - `table`: Name of the table to create.

    - *Default:* `#{__MODULE__ |> Inspect.inspect(%Inspect.Opts{})}.Table`

  - `named`: ETS named table option

    - *Default:* `false`

    - *Notes:* If making a non-private table it's reccommened to give your table a name.

  - `privacy`: ETS privacy option - `:public | :protected | :private`

    - *Default:* `:public`

  - `heir`: ETS heir option - `{pid, any} | nil`

    - *Default:* nil

  - `concurrent`: Whether or not to optimize access for concurrent reads or writes.

    - *Allowed:* `:reads | :writes | :both | false`

    - *Default:* `false`

  - `compressed`: Whether or not to compress the values being stored.

    - *Default:* `false`

  - `initial`: A map of key/value pairs to ensure are set on the DETS table at boot.

    - *Default:* `%{}`
  """
  def setup(config) do
    table   = Keyword.get(config, :table) || Module.concat(__MODULE__, Table)
    privacy = Keyword.get(config, :privacy) || :public
    heir    = Keyword.get(config, :heir) || :none
    read    = Keyword.get(config, :concurrent, false) in [:reads, :both]
    write   = Keyword.get(config, :concurrent, false) in [:writes, :both]

    options = [:set, privacy,
      heir: heir,
      read_concurrency: read,
      write_concurrency: write
    ]

    options = if Keyword.get(config, :named) do
      [:named_table | options]
    else
      options
    end

    options = if Keyword.get(config, :compressed) do
      [:compressed | options]
    else
      options
    end

    case :ets.new(table, options) do
      {:error, reason} -> {:stop, reason}
      state            -> {:ok, state}
    end
  end

  @spec get(Expander.Cache.Store.t, Expander.key)
    :: {:ok, Expander.Cache.Store.t, {:ok, Expander.value} | :error} | Expander.exception
  def get(store = %Store{state: table}, key) do
    case  :ets.lookup(table, key) do
      [{^key, value} | []] -> {:ok, store, {:ok, value}}
      []      -> {:ok, store, :error}
    end
  end

  @spec set(Expander.Cache.Store.t, Expander.key, Expander.value)
    :: {:ok, Expander.Cache.Store.t} | Expander.exception
  def set(store = %Store{state: table}, key, value) do
    if :ets.insert(table, {key, value}) do
      {:ok, store}
    else
      {:raise, Exception,
        message: "ETS operation failed: `:ets.insert(#{table}, {#{key}, #{value}})`"
      }
    end
  end
end
