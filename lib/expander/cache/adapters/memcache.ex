if Code.ensure_loaded?(Memcache) do
  defmodule Expander.Cache.Adapter.Memcache do

    @moduledoc ~S"""
    An adapter that uses Memcache as a caching engine.

    ## Example

        # config/config.exs
        config :sample, Sample.Expander,
          adapter: Expander.Cache.Adapter.Memcache

        # lib/sample/expander.ex
        defmodule Sample.Expander do
          use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Memcache
        end
    """
    use Expander.Cache.Adapter
    alias Expander.Cache.Store

    @doc """
    Connects to memcache to store data using provided `config`.

    ## Config

    - `initial:` A map of key/value pairs to ensure are set in memcached at boot.

      - *Default:* `%{}`

    All other options are passed verbatim to `Memcache.start_link/2`.
    """
    def setup(config) do
      Memcache.start_link(config)
    end

    @spec get(Expander.Cache.Store.t, Expander.key)
      :: {:ok, Expander.Cache.Store.t, {:ok, Expander.value} | :error} | Expander.exception
    def get(store = %Store{state: conn}, key) do
      case  Memcache.get(conn, key) do
        {:error, "Key not found"} -> {:ok, store, :error}
        {:ok, value}     -> {:ok, store, {:ok, value}}
      end
    end

    @spec set(Expander.Cache.Store.t, Expander.key, Expander.value)
      :: {:ok, Expander.Cache.Store.t} | Expander.exception
    def set(store = %Store{state: conn}, key, value) do
      case  Memcache.set(conn, key, value) do
        {:ok}      -> {:ok, store}
      end
    end
  end
end
