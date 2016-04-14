defmodule Garph.Mixfile do
  use Mix.Project

  def project do
    [app: :garph,
     version: "0.0.1",
     elixir: "~> 1.1",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Specifies which paths to compile
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    []
  end

  defp description do
    """
    Garph is a simple way to implement complex decision trees by using graphs. It can be used with plain elixir or beneath a phoenix project.
    """
  end

  defp package do
    [maintainers: ["Farhad Taebi", "Matthias Lindhorst"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/faber-lotto/garph"},
     files: ~w(mix.exs README.md test lib)]
  end
end
