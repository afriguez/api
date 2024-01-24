defmodule Api.Routes.V1 do
  use Plug.Router

  alias Api.Util
  alias Api.Clients.IGDB

  plug(:match)
  plug(:dispatch)

  get "/linux_bootstrap" do
    path = Path.join([:code.priv_dir(:api), "linux_bootstrap"])

    case File.read(path) do
      {:ok, data} ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, data)

      {:error, _reason} ->
        Util.respond(conn, {:error, "File not found."})
    end
  end

  get "/games/cover/:query" do
    %Plug.Conn{params: %{"query" => query}} = conn

    case IGDB.search_game(query) do
      {:ok, game} ->
        IO.inspect(game)
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

    case IGDB.search_game(query) do
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
