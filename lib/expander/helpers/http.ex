defmodule Expander.Helpers.Http do

  defp is_special_case(url) do
    url in [
      #"https://www.facebook.com/unsupportedbrowser"  # Facebook redirects HTTPotion to the unsupported browser page
    ]
  end

  defp handle_redirect(short, headers) do
    new_location = headers[:location]
    case is_special_case(new_location) do
      :true -> short
      :false -> expand(new_location)
    end
  end


  @spec expand(String.t) :: String.t
  def expand(short) do
    try do
      case HTTPotion.head(short, headers: ["User-Agent": Expander.Helpers.HttpAgent.agent(short)]) do

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
        %HTTPotion.Response{headers: headers, status_code: redirect} when 301 <= redirect and redirect <= 303 ->
          handle_redirect(short, headers)

        #
        # Some services disable the HEAD request and return 405 Method Not Allowed
        #
        %HTTPotion.Response{headers: _headers, status_code: 405} -> {:ok, short}
        %HTTPotion.Response{headers: _headers, status_code: success} when 200 <= success and success < 300 -> {:ok, short}

        #
        # Just for debugging
        # TODO: remove
        %HTTPotion.Response{status_code: redirect} ->
          IO.inspect redirect
         :error
      end
    rescue
      _ -> :error
    end
  end
end
