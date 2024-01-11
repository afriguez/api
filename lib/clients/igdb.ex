defmodule Api.Clients.IGDB do
  use HTTPoison.Base

  alias Api.Cache

  @endpoint "https://api.igdb.com/v4"

  def process_url(url) do
    @endpoint <> url
  end

  def headers do
    token = Application.get_env(:api, :token)
    client_id = Application.get_env(:api, :client_id)

    [
      {"Authorization", "Bearer " <> token},
      {"Client-ID", client_id}
    ]
  end

  def search_game(query) do
    get_or_fetch(:game, query, &fetch_game/1)
  end

  def search_game!(query) do
    case search_game(query) do
      {:ok, game} -> game
      {:error, reason} -> raise reason
    end
  end

  def get_cover(%{"cover" => ref_id}), do: get_cover(ref_id)

  def get_cover(ref_id) do
    get_or_fetch(:cover, ref_id, &fetch_cover/1)
  end

  defp get_or_fetch(type, key, f) do
    case Cache.get({type, key}) do
      {:ok, {:error, value}} ->
        {:error, value}

      {:ok, nil} ->
        item = f.(key)
        Cache.put({type, key}, item)
        item

      {:ok, value} ->
        value
    end
  end

  def get_cover!(ref_id) do
    case get_cover(ref_id) do
      {:ok, cover} -> cover
      {:error, reason} -> raise reason
    end
  end

  defp fetch_game(query) do
    %HTTPoison.Response{body: body} =
      post!(
        "/games",
        "fields *; search \"#{query}\"; limit 1;",
        headers()
      )

    body = Poison.decode!(body)

    if Enum.empty?(body) do
      {:error, "Game Not Found"}
    else
      {:ok, hd(body)}
    end
  end

  defp fetch_cover(ref_id) do
    %HTTPoison.Response{body: body} =
      post!(
        "/covers",
        "where id = #{ref_id}; fields url;",
        headers()
      )

    body = Poison.decode!(body)

    if Enum.empty?(body) do
      {:error, "Cover Not Found"}
    else
      {:ok, hd(body)}
    end
  end
end
