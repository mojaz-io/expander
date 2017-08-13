defmodule Expander.Helpers.Http do

  defp is_special_case(url) do
    url in [
      #"https://www.facebook.com/unsupportedbrowser"  # Facebook redirects HTTPotion to the unsupported browser page
    ]
  end

  defp handle_redirect(short, headers) do
    new_location = get_header(headers, "location")
    expand(new_location)

    #    new_location = headers[:location]
    #case is_special_case(new_location) do
    #  :true -> short
    #  :false -> expand(new_location)
    #end
  end

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
          handle_redirect(short, headers)

        #
        # Some services disable the HEAD request and return 405 Method Not Allowed
        #
        {:ok, %HTTPoison.Response{headers: _headers, status_code: 405}} -> {:ok, short}
        {:ok, %HTTPoison.Response{headers: _headers, status_code: success}} when 200 <= success and success < 300 -> {:ok, short}

        #
        # Just for debugging
        # TODO: remove
        {:ok, %HTTPoison.Response{status_code: redirect}} ->
          IO.inspect redirect
         :error
      end
    rescue
      _ -> :error
    end
  end
end
