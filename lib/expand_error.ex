defmodule Expander.ExpandError do
  defexception [reason: nil, payload: nil]

  def message(exception) do
    formatted = format_error(exception.reason, exception.payload)
    "expand error: #{formatted}"
  end


  defp format_error(:short_url_not_set, _), do: "expected \"short_url\" to be set"
  defp format_error(reason, _), do: "#{inspect reason}"
end
