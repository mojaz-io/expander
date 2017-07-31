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

      # Wrapper method around get to check if the item in cache.
      def in_cache(url, config) do
        case get(url, config) do
          {:ok, {_expanded, _config}} -> {:ok, true}
          _ -> {:ok, false}
        end
      end

      defp raise_on_missing_config([], _config), do: :ok
      defp raise_on_missing_config(key, config) do
        raise ArgumentError, """
        expected #{inspect key} to be set, got: #{inspect config}
        """
      end
    end
  end

  @type t :: module

  @type url :: Expander.Url.t

  @typep config :: Keyword.t

  @doc """
  Get URL from cache.
  """
  @callback get(url, config) :: {:ok, term} | {:error, term}

  @callback set(url, config) :: {:ok, term} | {:error, term}

  # @callback set(url, config)
end
