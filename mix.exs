defmodule AvroRPC.Mixfile do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :avro_rpc,
      version: "0.1.0",
      description: description(),
      package: package(),
      deps: deps(),
      elixir: "~> 1.4",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      # Docs
      name: "AvroRPC",
      source_url: "https://github.com/cafreeman/avro_rpc",
      docs: [
        main: "AvroRPC.Client",
        extras: ["README.md"]
      ]
    ]
  end

  defp description do
    """
    An Elixir package for making `AvroRPC` calls over TCP.
    """
  end

  defp package do
    [
      name: :avro_rpc,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Chris Freeman"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/cafreeman/avro_rpc"}
    ]

  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :eavro,
        :ex_avro
      ],
    # Specify extra applications you'll use from Erlang/Elixir
      extra_applications: [:logger],
      mod: {AvroRPC.Application, []},
    ]
  end

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
    [
      {:eavro, git: "https://github.com/sifoxdevteam/eavro.git", tag: "v0.0.3"},
      {:ex_avro, "~> 0.1.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end
