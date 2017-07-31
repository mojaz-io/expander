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
     deps: deps(),
     aliases: aliases(),]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :httpotion],
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
  defp deps do
    [{:httpotion, "~> 3.0.2"},
     {:ex_doc, "~> 0.15", only: :docs},
     {:inch_ex, ">= 0.0.0", only: :docs}]
  end


  defp aliases do
    ["test.ci": &test_ci/1]
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
