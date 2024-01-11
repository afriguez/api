defmodule Api do
  use Application

  import Cachex.Spec

  def start(_t, _a) do
    port = Application.get_env(:api, :port) |> String.to_integer()

    children = [
      {Plug.Cowboy, scheme: :http, plug: Api.Router, options: [port: port]},
      {Cachex,
       name: :api_cache,
       stats: true,
       limit:
         limit(
           size: 200,
           policy: Cachex.Policy.LRW,
           reclaim: 0.5
         )}
    ]

    opts = [strategy: :one_for_one, name: Api.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
