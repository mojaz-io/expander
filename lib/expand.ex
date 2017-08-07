defmodule Expander.Expand do

  @moduledoc ~S"""
  Defines an Expander.

  An expander is a wrapper around an adapter that makes it easy for you to swap the
  cache adapter without having to change your code.

  It is also responsible for doing some sanity checks before handing down the
  url to the adapter.

  When used, the expander expects `:otp_app` as an option.
  The `:otp_app` should point to an OTP application that has the expander
  configuration. For example, the expander:

      defmodule Sample.Expander do
        use Expander.Expand, otp_app: :sample
      end

  Could be configured with:

      config :sample, Sample.Expander,
        adapter: Expander.Cache.Adapter.Local,
        api_key: "x.x.x"

  Most of the configuration that goes into the config is specific to the adapter,
  so check the adapter's documentation for more information.

  Note that the configuration is set into your expander at compile time. If you
  need to reference config at runtime you can use a tuple like
  `{:system, "ENV_VAR"}`.

      config :sample, Sample.LocalCacheExpander,
        adapter: Expander.Cache.Adapter.Local

  ## Examples

  Once configured you can use your expander like this:

      # in an IEx console
      iex> url = new() |> short_url("http://amzn.to/2w9oM5d")
      %Expander.Url{long_url: nil, short_url: "http://amzn.to/2w9oM5d"}
      iex> Expander.expand(url)
      {:ok, {%Expander.Url{long_url: "http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create_dashboard.html?sc_channel=sm&sc_campaign=Docs&sc_publisher=TWITTER&sc_country=Global&sc_geo=GLOBAL&sc_outcome=[GLOBAL]&sc_content=Docs&linkId=40350988", short_url: "http://amzn.to/2w9oM5d"}, []}}

  You can also pass an extra config argument to `expand/2` that will be merged
  with your Expander's config:

      # in an IEx console
      iex> url = new() |> short_url("http://amzn.to/2w9oM5d")
      %Expander.Url{long_url: nil, short_url: "http://amzn.to/2w9oM5d"}
      iex> Expander.expand(url, tls: 100)
      {%Expander.Url{long_url: "http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create_dashboard.html?sc_channel=sm&sc_campaign=Docs&sc_publisher=TWITTER&sc_country=Global&sc_geo=GLOBAL&sc_outcome=[GLOBAL]&sc_content=Docs&linkId=40350988", short_url: "http://amzn.to/2w9oM5d"}, []}}
  """

  alias Expander.Helpers.Http
  alias Expander.ExpandError


  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      {otp_app, adapter, config} = Expander.Expand.parse_config(__MODULE__, opts)

      @adapter adapter
      @config config

      #
      # Validate the configuration before trying to start the server.
      # @TODO: If i moved this check inside the start_link function the raise will be not thrown
      #        and the server will fail to start silently. I need to figure out a way to make this
      #        cleaner.
      #
      :ok = @adapter.validate_config(@config)

      def expand(url) do
        #
        # Start the adapter and add it the cache supervisor tree.
        #
        case Expander.Cache.Supervisor.find_adapter(__MODULE__) do
          nil -> Expander.Cache.Supervisor.add_adapter(@adapter, @config, [name: __MODULE__])
          _ -> IO.puts "Adapter is already running"
        end

        Expander.Expand.expand(url, __MODULE__)
      end

      def expand!(url) do
        case expand(url) do
          {:ok, result} -> result
          {:error, reason} -> raise ExpandError, reason: reason
        end
      end

      def adapter do
        @adapter
      end

      def config do
        @config
      end

      ##
      def get(url)  do
        GenServer.call(__MODULE__, {:get, url})
      end

      ##
      def set(url)  do
        GenServer.call(__MODULE__, {:set, url})
      end

      ##
      def in_cache(url) do
        GenServer.call(__MODULE__, {:in_cache, url})
      end
    end
  end




  def expand(%Expander.Url{short_url: nil}, _server) do
    {:error, :short_url_not_set}
  end

  def expand(%Expander.Url{} = url, server) do
    #config = Expander.Expand.parse_runtime_config(config)
    #:ok = adapter.validate_config(config)

    #
    with {:ok, false} <- server.in_cache(url),
         {:ok, result} <- expand_remote(url),
         :ok <- server.set(result)
    do
          {:ok, result}
    else
      # URL already in cache.
      {:ok, true, cached_result} -> {:ok, cached_result}
      something_went_wrong ->
        IO.inspect something_went_wrong
        :error
    end
  end

  def expand_remote(url) do
    pid = Task.async(__MODULE__, :do_expand_remote, [url])
    Task.await(pid, :infinity)
  end

  def do_expand_remote(url) do
    case Http.expand(url.short_url) do
      {:ok, long_url} -> {:ok, url |> Expander.Url.long_url(long_url)}
      _ -> :error
    end
  end


  @doc """
  Parses the OTP configuration at compile time.
  """
  def parse_config(expander, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    config = Application.get_env(otp_app, expander, [])
    adapter = opts[:adapter] || config[:adapter]

    unless adapter do
      raise ArgumentError, "missing :adapter configuration in " <>
                           "config #{inspect otp_app}, #{inspect expander}"
    end


    config = parse_runtime_config(config)

    {otp_app, adapter, config}
  end


  @doc """
  Parses the OTP configuration at run time.
  This function will transform all the {:system, "ENV_VAR"} tuples into their
  respective values grabbed from the process environment.
  """
  def parse_runtime_config(config) do
    Enum.map config, fn
      {key, {:system, env_var}} -> {key, System.get_env(env_var)}
      {key, value} -> {key, value}
    end
  end
end
