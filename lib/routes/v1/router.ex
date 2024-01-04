defmodule Api.Routes.V1 do
  use Plug.Router

  alias Api.Clients.Games

  plug(:match)
  plug(:dispatch)

  get "/game/:query" do
    %Plug.Conn{params: %{"query" => query}} = conn

    cover =
      query
      |> Games.search_game("cover")
      |> Games.get_cover()

    url = String.replace(cover["url"], "t_thumb", "t_cover_big")
    data = %{cover | "url" => url}
    send_resp(conn, 200, Poison.encode!(%{success: true, data: data}))
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
