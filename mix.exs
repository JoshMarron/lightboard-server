defmodule LightboardServer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :lightboard_server,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LightboardServer, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:cowboy, "~> 1.1"},
        {:plug, "~> 1.4.3"},
        {:jason, "~> 1.0.0"},
        {:nerves_uart, "~> 1.0.0"}
    ]
  end
end
