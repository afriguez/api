defmodule Api.Routes.V1 do
  use Plug.Router

  alias Api.Clients.IGDB

  plug(:match)
  plug(:dispatch)

  get "/games/cover/:query" do
    %Plug.Conn{params: %{"query" => query}} = conn

    case IGDB.search_game(query, "cover") do
      {:ok, game} ->
        cover = IGDB.get_cover!(game)
        url = String.replace(cover["url"], "t_thumb", "t_cover_big")
        data = %{"url" => url}
        send_resp(conn, 200, Poison.encode!(%{success: true, data: data}))

      {:error, reason} ->
        send_resp(conn, 404, reason)
    end
  end

  get "/games/thumbnail/:query" do
    %Plug.Conn{params: %{"query" => query}} = conn

    case IGDB.search_game(query, "cover") do
      {:ok, game} ->
        cover = IGDB.get_cover!(game)
        data = %{"url" => cover["url"]}
        send_resp(conn, 200, Poison.encode!(%{success: true, data: data}))

      {:error, reason} ->
        send_resp(conn, 404, reason)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
