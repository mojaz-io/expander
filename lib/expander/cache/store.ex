defmodule Expander.Cache.Store do
  @type t :: %__MODULE__{
    adapter: Expander.Cache.Adapter.t,
    config:  Keyword.t,
    state: state :: term
  }
  @enforce_keys [:adapter, :config, :state]
  defstruct [:adapter, :config, :state]

  def new(adapter, config, state) do
    %__MODULE__{adapter: adapter, config: config, state: state}
  end
end
