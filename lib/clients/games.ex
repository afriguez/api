defmodule Api.Clients.Games do
  use HTTPoison.Base

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

  def search_game(query, fields \\ "*")

  def search_game(query, fields) do
    %HTTPoison.Response{body: body} =
      post!(
        "/games",
        "fields #{fields}; search \"#{query}\"; limit 1;",
        headers()
      )

    hd(Poison.decode!(body))
  end

  def get_cover(%{"cover" => ref_id}), do: get_cover(ref_id)

  def get_cover(ref_id) do
    %HTTPoison.Response{body: body} =
      post!(
        "/covers",
        "where id = #{ref_id}; fields url;",
        headers()
      )

    hd(Poison.decode!(body))
  end
end
