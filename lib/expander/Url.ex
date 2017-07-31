defmodule Expander.Url do
   @moduledoc """
    Defines an Expanding URL.

    This module defines a `Expander.Url` struct and the main functions for composing URL Expander.  As it is the contract for
    the public APIs of Expander it is a good idea to make use of these functions rather than build the struct yourself.

    ## Url fields

    * `short_url` - the short url before expanding, example: `"http://stpz.co/haddafios"`
    * `long_url` - the long url after expanding, example: `"https://itunes.apple.com/us/app/haddaf-hdaf/id872585884"`

    ## Examples

    url =
      new()
      |> short_url("http://stpz.co/haddafios")


    The composable nature makes it very easy to continue expanding upon a given url.
    url =
      url
      |> long_url("https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")


    You can also directly pass arguments to the `new/1` function.

    url = new(short_url: "http://stpz.co/haddafios", long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
   """

  defstruct short_url: nil, long_url: nil

  @type short_url :: URI.t
  @type long_url :: URI.t

  @type t :: %__MODULE__{short_url: URI.t, long_url: URI.t}

  @doc ~S"""
  Returns a `Expander.Url` struct.

  You can pass a keyword list or a map argument to the function that will be used
  to populate the fields of that struct. Note that it will silently ignore any
  fields that it doesn't know about.

  ## Examples
      iex> new()
      %Expander.Url{}

      iex> new(short_url: "http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios"}

      iex> new(long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
      %Expander.Url{long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884"}

    You can obviously combine these arguments together:

      iex> new(short_url: "http://stpz.co/haddafios", long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
      %Expander.Url{short_url: "http://stpz.co/haddafios", long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884"}
  """
  @spec new(none | Enum.t) :: t
  def new(opts \\ []) do
    Enum.reduce opts,  %__MODULE__{}, &do_new/2
  end

  defp do_new({key, value}, url)
    when key in [:short_url, :long_url] do
    apply(__MODULE__, key, [url, value])
  end

  defp do_new({key, value}, _url) do
    raise ArgumentError, message:
    """
    invalid field `#{inspect key}` (value=#{inspect value}) for Expander.Url.new/1.
    """
  end

  @doc """
  Sets the `short_url` field.

  The short_url must be a valid url.

  ## Examples
      iex> new() |> short_url("http://stpz.co/haddafios")
      %Expander.Url{short_url: "http://stpz.co/haddafios", long_url: nil}
  """
  @spec short_url(t, short_url) :: t
  def short_url(url, short_url) when is_binary(short_url) and byte_size(short_url) > 0 do
    case short_url |> validate_protocol |> validate_host |> validate_uri do
      {:ok, _} -> %{url|short_url: short_url}
      _ -> raise_invalid_url(short_url)
    end
  end

  def short_url(_url, short_url) do
    raise_invalid_url(short_url)
  end

  @doc """
  Sets the `long_url` field.

  The long_url must be a valid url.

  ## Examples
      iex> new() |> long_url("https://itunes.apple.com/us/app/haddaf-hdaf/id872585884")
      %Expander.Url{long_url: "https://itunes.apple.com/us/app/haddaf-hdaf/id872585884", short_url: nil}
  """
  @spec long_url(t, long_url) :: t
  def long_url(url, long_url) when is_binary(long_url) and byte_size(long_url) > 0 do
    case long_url |> validate_protocol |> validate_host |> validate_uri do
      {:ok, _} -> %{url|long_url: long_url}
      _ -> raise_invalid_url(long_url)
    end
  end

  def long_url(_url, long_url) do
    raise ArgumentError, message:
    """
    long_url/2 expects the short_url URL to be a strings.
    Instead it got:
      short_url: `#{inspect long_url}`.
    """
  end

  defp raise_invalid_url(url) do
    raise ArgumentError, message: """
    expects the url to be a valid url.
    Instead it got:
      `#{inspect url}`.
    """
  end

  defp validate_protocol("http://" <> rest = url) do
    {url, rest}
  end
  defp validate_protocol("https://" <> rest = url) do
    {url, rest}
  end
  defp validate_protocol(_), do: :error

  defp validate_host(:error), do: :error
  defp validate_host({url, rest}) do
    [domain | uri] = String.split(rest, "/")
    case String.to_char_list(domain) |> :inet_parse.domain do
      true -> {url, Enum.join(uri, "/")}
      _ -> :error
    end
  end

  defp validate_uri(:error), do: :error
  defp validate_uri({url, uri}) do
    if uri == URI.encode(uri) |> URI.decode do
      {:ok, url}
    else
      :error
    end
  end

end
