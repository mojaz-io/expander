# defmodule Expander.Cache.Adapter.RedixTest do
#   use ExUnit.Case, async: true

#   setup do
#     on_exit fn ->
#       IO.puts "xxxxxxxxxxxxxxxxxxxxxxxx"
#       #Supervisor.stop(Expander.Cache.Adapter.Redix)
#       :ok
#     end
#   end

#   Application.put_env(
#     :expander,
#     Expander.Cache.Adapter.RedixTest.RedisCache,
#     host: System.get_env("REDIX_TEST_HOST") || "localhost",
#     port: String.to_integer(System.get_env("REDIX_TEST_PORT") || "6379")
#   )

#   defmodule RedisCache do
#     use Expander.Expand, otp_app: :expander, adapter: Expander.Cache.Adapter.Redix
#   end

#   @tag :wip
#   test "test"  do
#   #  url = Expander.Url.new(short_url: "http://stpz.co/haddafios")
#   #  x = RedisCache.expand(url)
#   end


# end
