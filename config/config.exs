import Config

config :api, Api.Repo,
  database: "api_repo",
  username: "postgres",
  password: "",
  hostname: "localhost"

config :api, ecto_repos: [Api.Repo]
