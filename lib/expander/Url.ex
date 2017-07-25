defmodule Expander.Url do
  defstruct short: nil, long: nil

  @type short :: URI.t
  @type long :: URI.t

  @type t :: %__MODULE__{short: URI.t, long: URI.t}

  @spec new(none | Enum.t) :: t
  def new(opts \\ []) do
    Enum.reduce opts,  %__MODULE__{}, &do_new/2
  end

  defp do_new({key, value}, url)
    when key in [:short, :long] do
    apply(__MODULE__, key, [url, value])
  end

  defp do_new({key, value}, _url) do
    raise ArgumentError, message:
    """
    invalid field `#{inspect key}` (value=#{inspect value}) for Expander.Url.new/1.
    """
  end

  @spec short(t, short) :: t
  def short(url, short), do: %{url|short: short}

  @spec long(t, long) :: t
  def long(url, long), do: %{url|long: long}


end
