defmodule Api do
  use Application

  def start(_t, _a) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Api.Router, options: [port: 4321]}
    ]

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
