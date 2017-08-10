if Code.ensure_loaded?(Redix) do
  defmodule Expander.Cache.Adapter.Redix do

    @moduledoc ~S"""
    An adapter that uses Redis as a caching engine.

    ## Example

        # config/config.exs
        config :sample, Sample.Expander,
          adapter: Expander.Cache.Adapter.Redix,
          conn: [host: "localhost", port: 6379]

        # lib/sample/expander.ex
        defmodule Sample.Expander do
          use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Redix
        end
    """
    use Expander.Cache.Adapter #, required_config: [:host, :port]
    alias Expander.Cache.Store

    defmodule Exception do
      defexception [:message]
    end

    @doc """
    Connects to redis to store data using provided `config`.

    ## Config

    - `conn:` The Redis to connect to, as either a string or list of opts w/ host, port, password, and database.

      - *Default:* `"redis://localhost:6379"`

    - `initial:` A map of key/value pairs to ensure are set in redis at boot.

      - *Default:* `%{}`

    All other options are passed verbatim to `Redix.start_link/2`.
    """
    def setup(config) do
      {conn, options} = Keyword.get_and_update(config, :conn, fn _ -> :pop end)

      Redix.start_link(conn || "redis://localhost:6379", options)
    end

    @spec get(Expander.Cache.Store.t, Expander.key)
      :: {:ok, Expander.Cache.Store.t, {:ok, Expander.value} | :error} | Expander.exception
    def get(store = %Store{state: conn}, key) do
      case  Redix.command(conn, ["GET", key]) do
        {:ok, nil}       -> {:ok, store, :error}
        {:ok, value}     -> {:ok, store, {:ok, value}}
      end
    end

    @spec set(Expander.Cache.Store.t, Expander.key, Expander.value)
      :: {:ok, Expander.Cache.Store.t} | Expander.exception
    def set(store = %Store{state: conn}, key, value) do
      command = ["SET", key, value]
      case  Redix.command(conn, command) do
        {:ok, "OK"}      -> {:ok, store}
      end
    end
  end
end
