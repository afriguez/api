defmodule Api.Cache do
  @cache :api_cache

  def put(key, data) do
    Cachex.put(@cache, key, data)
  end

  def get(key) do
    Cachex.get(@cache, key)
  end
end
