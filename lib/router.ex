defmodule Api.Router do
  use Plug.Router

  alias Api.Routes.V1

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  forward("/v1", to: V1)

  get "/" do
    data = %{
      about: "Personal API for projects related to https://afriguez.com"
    }

    send_resp(conn, 200, Poison.encode!(%{success: true, data: data}))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
