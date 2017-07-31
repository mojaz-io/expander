defmodule Expander.Helpers.Http do

  defp is_special_case(url) do
    url in [
      "https://www.facebook.com/unsupportedbrowser"  # Facebook redirects HTTPotion to the unsupported browser page
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
      case HTTPotion.head(short) do
        %HTTPotion.Response{headers: headers, status_code: redirect} when 301 <= redirect and redirect <= 302 ->
          handle_redirect(short, headers)
        # Assumes all shortening services respond to HEAD and that target URLs may not.
        # In that case expansion is done.
        %HTTPotion.Response{headers: _headers, status_code: 405} -> {:ok, short}
        %HTTPotion.Response{headers: _headers, status_code: success} when 200 <= success and success < 300 -> {:ok, short}
      end
    rescue
      _ -> :error
    end
  end
end
