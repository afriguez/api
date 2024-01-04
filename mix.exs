defmodule Api.MixProject do
  use Mix.Project

  def project do
    [
      app: :api,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Api.Application, []}
    ]
  end

  defp deps do
    [
      {:plug_cowboy, "~> 2.6.1"},
      {:poison, "~> 5.0"},
      {:httpoison, "~> 2.2"}
    ]
  end
end
