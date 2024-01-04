import Config

config :api,
  token: System.get_env("API_TWITCH_TOKEN"),
  client_id: System.get_env("API_TWITCH_CLIENT_ID"),
  client_secret: System.get_env("API_TWITCH_CLIENT_SECRET")
