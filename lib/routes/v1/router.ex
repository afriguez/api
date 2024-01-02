defmodule Api.Routes.V1 do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/game/:query" do
    # %Plug.Conn{params: %{"query" => query}} = conn
    send_resp(conn, 200, "OK")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
