defmodule AvroRPC.Mixfile do
  use Mix.Project

  def project do
    [app: :avro_rpc,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
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
      mod: {AvroRPC.Application, %{hostname: "localhost", port: 9015, protocol: Path.absname("./test/data/avro.json")}}
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
    ]
  end
end
