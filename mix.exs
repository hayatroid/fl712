defmodule Fl712.MixProject do
  use Mix.Project

  def project do
    [
      app: :fl712,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fl712.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:websockex, "~> 0.5.1"},
      {:jason, "~> 1.4"},
      {:req, "~> 0.5.17"}
    ]
  end
end
