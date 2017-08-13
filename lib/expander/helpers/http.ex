defmodule Expander.Helpers.Http do

  defp get_header(headers, key) do
    headers
    |> Enum.filter(fn({k, _}) -> String.downcase(k) == key end)
    |> hd
    |> elem(1)
  end


  @spec expand(String.t) :: String.t
  def expand(short) do
    try do
      case HTTPoison.head(short, ["User-Agent": Expander.Helpers.HttpAgent.agent(short)], []) do

        #
        # Some websites like tiny.cc return with HTTP status 303 [SEE OTHER] https://httpstatuses.com/303
        #
        # if the header is:
        #   301 Moved Permanently
        #   302 Found
        #   303 See Other
        #
        # then deal with the redirection.
        #
        {:ok, %HTTPoison.Response{headers: headers, status_code: redirect}} when 301 <= redirect and redirect <= 303 ->
          headers |> get_header("location") |> expand

        #
        # Some services disable the HEAD request and return 405 Method Not Allowed
        #
        {:ok, %HTTPoison.Response{headers: _headers, status_code: 405}} -> {:ok, short}
        {:ok, %HTTPoison.Response{headers: _headers, status_code: success}} when 200 <= success and success < 300 -> {:ok, short}

        #
        # Default fallback
        #
        {:ok, %HTTPoison.Response{status_code: redirect}} -> {:error, "#{short} returned with states_code: #{redirect}"}
      end
    rescue
      x -> {:error, "#{short} raised: #{x}"}
    end
  end
end
