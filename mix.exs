defmodule LifeCalendar.MixProject do
  use Mix.Project

  def project do
    [
      app: :life_calendar,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LifeCalendar.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.1.0"},
      {:phoenix, "~> 1.7.7"},
      {:phoenix_ecto, "~> 4.4.2"},
      {:ecto_sql, "~> 3.10.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.3.1"},
      {:phoenix_live_reload, "~> 1.4.1", only: :dev},
      {:phoenix_live_view, "~> 0.19.5"},
      {:floki, ">= 0.34.3", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.1"},
      {:esbuild, "~> 0.7.1", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.1", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.11.5"},
      {:finch, "~> 0.16.0"},
      {:telemetry_metrics, "~> 0.6.1"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.23.1"},
      {:jason, "~> 1.4.1"},
      {:plug_cowboy, "~> 2.6.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
