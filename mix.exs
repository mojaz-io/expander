defmodule Expander.Mixfile do
  use Mix.Project

  @version "0.0.1"

  def project do
    [app: :expander,
     version: @version,
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     # Hex
     description: description(),
     package: package(),

     deps: deps(),
     aliases: aliases(),
     test_coverage: [tool: ExCoveralls],

     # Docs
     name: "Expander",
     docs: [source_ref: "v#{@version}", main: "Expander",
            canonical: "http://hexdocs.pm/expander",
            source_url: "https://github.com/mojaz-io/expander"]]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Expander.Application, []}]
  end

  defp elixirc_paths(:test), do: ["lib"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps, do: tools() ++ backends()

  defp tools, do: [
    {:httpoison, "~> 0.12"},
    {:poolboy, "~> 1.5"},
    {:poison, "~> 3.1"},
    {:ex_doc, "~> 0.15", only: :docs},
    {:excoveralls, "~> 0.6",  only: [:docs, :test]},
    {:inch_ex,     "~> 0.5",  only: [:docs]},
  ]

  defp backends, do: [
    {:redix, ">= 0.0.0", only: [:dev, :test, :docs]},
    {:memcachex, ">= 0.0.0", only: [:dev, :test, :docs]},
  ]


  defp aliases do
    ["test.ci": &test_ci/1]
  end

  defp description do
    """
    A library to expand/unshorten urls with unified cache store.
    """
  end

  defp package do
    [maintainers: ["Moski Doski"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/mojaz-io/expander"}]
  end

  defp test_ci(args) do
    args = if IO.ANSI.enabled?, do: ["--color"|args], else: ["--no-color"|args]
    args = if System.get_env("TRAVIS_SECURE_ENV_VARS") == "true", do: ["--include=integration"|args], else: args

    {_, res} = System.cmd("mix",
                          ["test"|args],
                          into: IO.binstream(:stdio, :line),
                          env: [{"MIX_ENV", "test"}])

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end
end
