Application.put_env(
    :expander,
    RedisCache,
    host: System.get_env("REDIX_TEST_HOST") || "localhost",
    port: String.to_integer(System.get_env("REDIX_TEST_PORT") || "6379")
)

Application.put_env(:expander,RedisCache)



defmodule RedisCache do
  use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Redix
end

url = Expander.Url.new(short_url: "http://stpz.co/haddafios")
RedisCache.expand(url)

[head|tail] = Expander.Cache.Supervisor.adapters
Expander.Cache.Supervisor.find_adapter(head)




:observer.start
