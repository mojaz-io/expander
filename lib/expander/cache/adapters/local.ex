defmodule Expander.Cache.Adapter.Local do
  use Expander.Cache.Adapter

  def get(%Expander.Url{} = url, config) do
    driver = storage_driver(config)
    case driver.get(url.short_url) do
      %Expander.Url{} = expanded -> {:ok, {expanded, config}}
      _ -> {:error, :url_not_found}
    end
  end

  def set(%Expander.Url{} = url, config) do
    driver = storage_driver(config)
    expanded = driver.set(url)
    {:ok, {expanded, config}}
  end

  defp storage_driver(config) do
    config[:storage_driver] || Expander.Cache.Adapters.Local.Storage.Memory
  end
end
