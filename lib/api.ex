defmodule Api do
  use Application

  def start(_t, _a) do
    port = Application.get_env(:api, :port) |> String.to_integer()

    children = [
      {Plug.Cowboy, scheme: :http, plug: Api.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
