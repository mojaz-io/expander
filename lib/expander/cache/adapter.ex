defmodule Expander.Cache.Adapter do
  @moduledoc ~S"""
  Specification of getting and saving url from cache adapter.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @required_config opts[:required_config] || []

      @behaviour Expander.Cache.Adapter

      def validate_config(config) do
        missing_keys = Enum.reduce(@required_config, [], fn(key, missing_keys) ->
          if config[key] in [nil, ""], do: [key | missing_keys], else: missing_keys
        end)
        raise_on_missing_config(missing_keys, config)
      end

      defp raise_on_missing_config([], _config), do: :ok
      defp raise_on_missing_config(key, config) do
        raise ArgumentError, """
        expected #{inspect key} to be set, got: #{inspect config}
        """
      end

      # Defoverridable makes the given functions in the current module overridable
      # Without defoverridable, new definitions of start_link/1 will not be picked up
      #defoverridable [start_link: 1]
    end
  end

  @type t :: module
  @typep config :: Keyword.t

  @callback setup(config) :: {:ok, state :: term} | :ignore | {:stop, reason :: term}

  @doc """
  Get URL from cache.
  """
  @callback get(Expander.Cache.Store.t, Expander.key) :: {:ok, Expander.Cache.Store.t, {:ok, Expander.value} | :error} | Expander.exception

  @doc """
  Set URL in cache.
  """
  @callback set(Expander.Cache.Store.t, Expander.key, Expander.value) :: {:ok, Expander.Cache.Store.t} | Expander.exception
end
