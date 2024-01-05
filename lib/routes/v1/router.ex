defmodule Api.Routes.V1 do
  use Plug.Router

  alias Api.Util
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
        Util.respond(conn, {:ok, data})

      error ->
        Util.respond(conn, error)
    end
  end

  get "/games/thumbnail/:query" do
    %Plug.Conn{params: %{"query" => query}} = conn

    case IGDB.search_game(query, "cover") do
      {:ok, game} ->
        cover = IGDB.get_cover!(game)
        data = %{"url" => cover["url"]}
        Util.respond(conn, {:ok, data})

      error ->
        Util.respond(conn, error)
    end
  end

  match _ do
    Util.respond(conn, {:error, "Not Found"})
  end
end
